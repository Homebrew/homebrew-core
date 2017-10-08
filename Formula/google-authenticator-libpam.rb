class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/1.04.tar.gz"
  sha256 "8284cc046be436513d9d4bbb1285017327edbcc32f6f620c47e7e889c4b966ef"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "qrencode" => :recommended

  def install
    system "./bootstrap.sh"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add 2-factor authentication for ssh:
      echo "auth required /usr/local/lib/security/pam_google_authenticator.so" \\
      | sudo tee -a /etc/pam.d/sshd

    Add 2-factor authentication for ssh allowing users to log in without OTP:
      echo "auth required /usr/local/lib/security/pam_google_authenticator.so" \\
      "nullok" | sudo tee -a /etc/pam.d/sshd

    (Or just manually edit /etc/pam.d/sshd)

    Users can set up Google Authenticator interactively using:
      google-authenticator

    Users can set up Google Authenticator with default settings using:
      google-authenticator --force --time-based --disallow-reuse --rate-limit=3 \\
      --rate-time=30 --window-size=3
    EOS
  end

  test do
    system "#{bin}/google-authenticator", "--help"
  end
end
