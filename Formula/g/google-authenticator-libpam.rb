class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/1.09.tar.gz"
  sha256 "ab1d7983413dc2f11de2efa903e5c326af8cb9ea37765dacb39949417f7cd037"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "9fca52360d304b8eedefb9ea55203072539036ba7bbf876b487a226200c29b2a"
    sha256 cellar: :any,                 arm64_ventura:  "e481b47a941b3e2035b16ff10190b28de5aaeeb9d7f76ba03bbb778d31352cd6"
    sha256 cellar: :any,                 arm64_monterey: "c813753b6fa666210c3e03746dc85ba8f96b4f086b32e565eab286919c9bcdb2"
    sha256 cellar: :any,                 arm64_big_sur:  "5fcc93296963e8ddabb631618dabdb3a09ca296a49c6f86165dbb76199007759"
    sha256 cellar: :any,                 sonoma:         "49d403a52389854edcd50d883bf343d15fa57d34999af4ad982ac618494a5d05"
    sha256 cellar: :any,                 ventura:        "d2a5423387b0cf36704fa1428a07e7e2be88ae542ff80e3c12e391fff0da05e7"
    sha256 cellar: :any,                 monterey:       "a8da4f8e9aa2b2126e3248f103b95734ea640d9c398d23b2ece251cac88c8eef"
    sha256 cellar: :any,                 big_sur:        "8ce2c19632d8f25e92f0b161fc5f07527f1e6fca35cb1ec97516903d8b254887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08220804780bdf668e9753dae17442d1c344d6d4f7637e441a9b38f913426f95"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "qrencode"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["qrencode"].lib}"
    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules"
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
    system bin/"google-authenticator", "--force", "--time-based",
           "--disallow-reuse", "--rate-limit=3", "--rate-time=30",
           "--window-size=3", "--no-confirm"
  end
end
