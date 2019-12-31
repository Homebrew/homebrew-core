class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/1.08.tar.gz"
  sha256 "6f6d7530261ba9e2ece84214f1445857d488b7851c28a58356b49f2d9fd36290"

  bottle do
    cellar :any_skip_relocation
    sha256 "a079d10d1e6bb920d1981d994a40643a592d6af2c3f8d45265e070b613b7f332" => :catalina
    sha256 "e5f1db2b8216b360ef95e86e59aedcba7679bdb3e5d2f72b3848a243382b4e47" => :mojave
    sha256 "8f07cb758011d0eb1439f3f6e0b6326156a65d2525725125b4c27fdcd28930dd" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "qrencode"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add 2-factor authentication for ssh:
      echo "auth required #{opt_lib}/security/pam_google_authenticator.so" \\
      | sudo tee -a /etc/pam.d/sshd

    Add 2-factor authentication for ssh allowing users to log in without OTP:
      echo "auth required #{opt_lib}/security/pam_google_authenticator.so" \\
      "nullok" | sudo tee -a /etc/pam.d/sshd

    (Or just manually edit /etc/pam.d/sshd)
  EOS
  end

  test do
    system "#{bin}/google-authenticator", "--force", "--time-based",
           "--disallow-reuse", "--rate-limit=3", "--rate-time=30",
           "--window-size=3", "--no-confirm"
  end
end
