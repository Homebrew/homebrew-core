class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/1.08.tar.gz"
  sha256 "6f6d7530261ba9e2ece84214f1445857d488b7851c28a58356b49f2d9fd36290"

  bottle do
    cellar :any_skip_relocation
    sha256 "024679fc7963c416632e422af276ab10bb129740c7d081fadb9ee936695f57da" => :catalina
    sha256 "2317849932e770a926b427589058d6b552326d84376f714199e75aa9c922377d" => :mojave
    sha256 "b94306ade72a66cb67a8d3929f98349a01fd33b2b382a457bfecb8e1dde17380" => :high_sierra
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

  def caveats
    <<~EOS
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
