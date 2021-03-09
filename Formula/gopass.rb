class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.1/gopass-1.12.1.tar.gz"
  sha256 "ab38e0a6d6a1938b03b3fa31c969b8cf05692b36acbb1b0e2fed121365852510"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "38fbe5a5ce0fc2d1a73a131de0a0234241aa0291d1e0f6594dc25a4768d24fc7"
    sha256 cellar: :any_skip_relocation, big_sur:       "889f30e3d3cda33a3146f9a52659d5868bf6ff07025f9bdf64ae42ec075681b6"
    sha256 cellar: :any_skip_relocation, catalina:      "8efa4de9a7569c395afbe7721f6ea0bb572d8c6dd69a92568bac876576662b2b"
    sha256 cellar: :any_skip_relocation, mojave:        "252cb69daf2c96836574596cfca87d6d2b7e94335c34267f275af37e0cc12f2d"
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
