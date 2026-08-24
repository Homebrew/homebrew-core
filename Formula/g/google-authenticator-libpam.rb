class GoogleAuthenticatorLibpam < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator-libpam"
  url "https://github.com/google/google-authenticator-libpam/archive/refs/tags/1.11.tar.gz"
  sha256 "3ee08a6dd46aace7dba1c88cf47e9cd267447ccd1cd8be1d5a05fd0e6816062d"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a17099cc9735309f5d725c89fdbba27bf1e1e935e1c2cd82e67a109af595cd9f"
    sha256 cellar: :any, arm64_sequoia: "98e2cf64e941d7fa153e15a3ebd7998614442951fc5e99c9745c988b7b582ba0"
    sha256 cellar: :any, arm64_sonoma:  "91f85a6f6b124ca0c30387349a957dd915234e7469b7044c506713661813fc1b"
    sha256 cellar: :any, sonoma:        "7f7ec765e16362f48a27fedeb996113bd7c0bba024488c360ae700da6f0c946c"
    sha256 cellar: :any, arm64_linux:   "66333f19942f381adffcc55fc75223e741722d667064bf9cdc8aab9c9c9d758f"
    sha256 cellar: :any, x86_64_linux:  "fd5066487cb83cb932c4a534cc8e5de72a1462ac8bc01517680c7139cb50b4c3"
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
