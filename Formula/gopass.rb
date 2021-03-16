class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.2/gopass-1.12.2.tar.gz"
  sha256 "b4254ecbc14b62a68e1e98c99d08d53c50a5b5b15b8b5b592266a6d581c93f13"
  license "MIT"
  revision 1
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "687c1702f659299c6207330938716ac7a742f6f2c9f3fd806c7cf87836d47970"
    sha256 cellar: :any_skip_relocation, big_sur:       "c54d0015557a42bb8ff45f6b5727ba09a6bb926f19fe57c51c7803ade0f2d01a"
    sha256 cellar: :any_skip_relocation, catalina:      "85b54fce51edccec19b757f8bb9965e0e260d750832ec953643ce0fce7f42582"
    sha256 cellar: :any_skip_relocation, mojave:        "b236144cf649f9ebd86002bcb121558f1579abaffd1daf798f7d5ff59d604609"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args

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
