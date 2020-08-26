class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.10.1/gopass-1.10.1.tar.gz"
  sha256 "23e7cf39938fcc34856ec4e6abce740a9be9fe8fa68cf8a6f61ca497fe6f9283"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af6dfa86d62d357d3c2d9f1a0a8f32b04fd40d42b8faa6efb08a68b36cdff1e9" => :catalina
    sha256 "19cad2bc10df7892331a365ae680bd8f363a8b6195d991451ed8d67dfbbddeef" => :mojave
    sha256 "81d87be46646ad9db03053a8ad3339ea684d6bfb3850885c329fd934ef332a8e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gnupg"
  depends_on "terminal-notifier"

  def install
    ENV["GOBIN"] = bin

    system "go", "install", "-ldflags", "-s -w -X main.version=#{version}", "./..."

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/gopass", "completion", "bash")
    (bash_completion/"gopass").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/gopass", "completion", "zsh")
    (zsh_completion/"_gopass").write output

    output = Utils.safe_popen_read({ "SHELL" => "fish" }, "#{bin}/gopass", "completion", "fish")
    (fish_completion/"gopass.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/"Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
