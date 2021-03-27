class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.5/gopass-1.12.5.tar.gz"
  sha256 "2b6d8da5ed88ae02a2666cadcffbd0a60ce93bfd0a44f9b460a7e4ab2b1ed773"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "394e0609baf7392eb37206e662d7ad06c126e12c6b500e7b791ad5649d76446a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6a1e5fddf989795ce7620b979dbb05489650f51e2cd38e664425557057c9f6d"
    sha256 cellar: :any_skip_relocation, catalina:      "b1382266a2616e7294d905d5a55b2996eea1b86c479cb369590af4895d47c53f"
    sha256 cellar: :any_skip_relocation, mojave:        "352982b80a0e184d61911ed9e4fc5023e327757bee8228a3cdf6c9d8cba4f8e4"
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
