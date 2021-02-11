class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.0/gopass-1.12.0.tar.gz"
  sha256 "6208b32a7000eda3b2b4f7f11ddcb913253937e94764f79253dd76860ea57930"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7fc7647c0acc4926b64323f33bde8ab45a5ef27726ba28ef7f9a6547e2d8855b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c31ac893183875bcc18fe9e6b5d7dc3d17b2ae5c7a08003ae89d6d376210718a"
    sha256 cellar: :any_skip_relocation, catalina:      "ece67ff90db85385a0a86391daa08cae2d164198949874ef94b61cf69a198547"
    sha256 cellar: :any_skip_relocation, mojave:        "9496cccc95ce43ffa04d153ec36cb22d8a3e3f7c1ac3380d633421ef034b4640"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

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
