class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/refs/tags/1.10.tar.gz"
  sha256 "6fe08e7a73ed8f176569c3ad6ad95a5677873e59300d463a2d962c92685a8596"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c130f29a24800a76d13547a22463c9ad4ee38214760ab53e9f3962b00d4493a1"
    sha256 cellar: :any,                 arm64_ventura:  "c37f8bf7b51cc2be2491a9d8fceabcbdbf9bea26e401bc36bae438327f3f947e"
    sha256 cellar: :any,                 arm64_monterey: "7050f1ebe26b7ca31601eef8cab6231b9b0e8856e59d9c47c4d2bce99803e8c8"
    sha256 cellar: :any,                 sonoma:         "2043b4d7e700e9716e2e20c7289794e3f744db11e33f8ff97531d884f9a78ace"
    sha256 cellar: :any,                 ventura:        "a08e6a718f468c1ccc218258ad304b57dec57a14a7dd4384c00edcf6ae45548a"
    sha256 cellar: :any,                 monterey:       "e59df1d930b00b2caf4f03e9b2e9c0a6f0502706e98bb1f2c0873d96ce9f7a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d9a5c7680d94e3ff83b8c38eec4450c933e15d9135b7e270508f500b0ebe920"
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
