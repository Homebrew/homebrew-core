class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/refs/tags/1.11.tar.gz"
  sha256 "3ee08a6dd46aace7dba1c88cf47e9cd267447ccd1cd8be1d5a05fd0e6816062d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd5ef94f8320f6da49f1cfa681d63bb58d9578ced890f6b1c2811b5451755e0f"
    sha256 cellar: :any,                 arm64_sequoia: "f2452e49e52b39b37fdbbdadc0d18cee36e55b0e75ccec2c46656597a7c839d5"
    sha256 cellar: :any,                 arm64_sonoma:  "35fe2b51a3349de745e6d29f7debd894b6d2430933b3a39e7b0b32500a3ee945"
    sha256 cellar: :any,                 arm64_ventura: "a74302d80e616251e9e877a99ec537d7fe8ac1d8054278df74c85bd84cb24436"
    sha256 cellar: :any,                 sonoma:        "e8b04f1bb3a6d429869277493bde331a2423ebb8d4f79e59b2eda25f6878521d"
    sha256 cellar: :any,                 ventura:       "31ab70bcbadee31ff695efad9503ad90d0041d0bae0168aaae4dfb72b4613f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a271e3a3354b737df9b52c0d00182d8a129c4bf4785fbcf024bedfaebbe9c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664d3b02168d36aedad5165ad643a50686c1cc673b26333d119ffecc51ab92bc"
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
