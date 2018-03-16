class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/1.05.tar.gz"
  sha256 "862412d6927ee1a19d81150006d53c21935897ba6d033616c31fc4d6aaa4db08"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b76859ee4008c2d66712585617f0b47d5a40cb4583fda5784f9b7f05260387e" => :high_sierra
    sha256 "1082f7a7a81ac9e3045176b66baedbdf956aca8ccd7e4b008013b24f0d2ed3c2" => :sierra
    sha256 "2d48707e7e2dc9821c6954295c983ad76c9edcd6bac71f9da1cb2ecdb7b560a2" => :el_capitan
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
           "--window-size=3"
  end
end
