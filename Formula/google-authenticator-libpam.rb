class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/1.06.tar.gz"
  sha256 "52f03ec746e8deb1af37911697d096f0fa87583491b7cc460cdf09a6ef0d6b06"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa5f60e9fa0a2d69c03127e9398d495d4bf06c4fea64d3dc4b9b6d7b94c7f1d1" => :catalina
    sha256 "7705a1508ebbf3b288dd23864957af565d0133300808325aae1be638db759aa3" => :mojave
    sha256 "95296464b3cc30ae3120d74c2a00ebd7f48270313cdf3e5f2e17149e5811bf23" => :high_sierra
    sha256 "2555908b0fe0caaed427bb7722a8fd84c3495732db7a95c241b078850e3b140b" => :sierra
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
