class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.6/gopass-1.12.6.tar.gz"
  sha256 "eeab6c62ae7586d9e1f50a664298a06afc7e30b7394bcd254a91abccf30bfa70"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "204f7dd4b000c723a33f49d422d7c8b9e9b4b3663c48c970ca51e01e1ca8c2da"
    sha256 cellar: :any_skip_relocation, big_sur:       "a635556cee22ee5daf58848307fb76dc060b5d99faf9105544e58e5c1e267d24"
    sha256 cellar: :any_skip_relocation, catalina:      "c558ad0e1d9713da971713ad276363d608bd81c12eb0a605f9bfc0aa974f9ed2"
    sha256 cellar: :any_skip_relocation, mojave:        "5d766e95771c8c6bbfce80f350887e97d54a2dc8d98a7bf4874c531a3e0e6e38"
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
