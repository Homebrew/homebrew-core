class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.13.0/gopass-1.13.0.tar.gz"
  sha256 "af51f9a34851c5d6f9982466ef973d28098b77e241520ee452994592baf6cb64"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b3a2d21f42becfe8debdf2ad9d07a9e10fc1b0091f4d2412d0f409a868ec481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5789a0d9e09bac19377872ac407726adeebeaf1e70cf2151e97449da37f0048"
    sha256 cellar: :any_skip_relocation, monterey:       "28b1abc7fb231fc86173ad55dfa9a1a18929720269d35e2c3f3e4e97a1c7f9ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "561cbbe9cf4b0cb65956e6ad470556b3537f39ae4a63121431c7a6f29fc33b4b"
    sha256 cellar: :any_skip_relocation, catalina:       "3abcdfb41a3c82b11982149a06cdcf56604db71837cdf3949cd308347e739191"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"
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
