class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.6/gopass-1.12.6.tar.gz"
  sha256 "eeab6c62ae7586d9e1f50a664298a06afc7e30b7394bcd254a91abccf30bfa70"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3478ee7ef96950334819da9c368505a19d62ea32574144f296eb97ee8da3b79d"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c50579914e06fd2472e2ea3578408f8c678c03dd3880becf553c1d5103d04b9"
    sha256 cellar: :any_skip_relocation, catalina:      "832b3db15efdd636e927917c531bcdfe81e8520809b02033dad924605d60ce82"
    sha256 cellar: :any_skip_relocation, mojave:        "69af555d7e5464bd7f5c412a4ced71ace78831220afbb3e9fc79e08762060fbd"
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
