class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.3.0.tar.gz"
  sha256 "72360c6875485eb4df409da8f8f52b17893f05e4d998529c238814480e115220"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/pam-u2f.git", branch: "master"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fdbd7c54fa5226be9818e5885dfce1aec74ebeb01dfee779814ac6d979c69852"
    sha256 cellar: :any,                 arm64_sonoma:   "d319d3bb317cedcfa9505c05467673dc8f1a13fbc282518b0d6ee21a6cf59d8b"
    sha256 cellar: :any,                 arm64_ventura:  "45630c8a3a007708310edd878ce19476d8424244f90275748dde69ca059a8e38"
    sha256 cellar: :any,                 arm64_monterey: "a276d4e8b21f4b15c46e8d27fb84ba42076aa280a20e3b19ce8cae7c45eedb3d"
    sha256 cellar: :any,                 arm64_big_sur:  "f8dc0e2ba0fb4fa6e1724e6503a3d553bf2e377d0f7da9ae340e59424c097b82"
    sha256 cellar: :any,                 sonoma:         "2a1552fdd63938e97265cb694374bc87153d62af389df3a57ce91ec902d8cb66"
    sha256 cellar: :any,                 ventura:        "20e00da7179d67f0bac63ca36ecc33962dcc087632e0bc98844ad105122f6dd1"
    sha256 cellar: :any,                 monterey:       "a43bfbe53c8da19aa1f4f24e99af78ffd20855fadbd8cc12fd2e66890e527daf"
    sha256 cellar: :any,                 big_sur:        "8bb7a56a9a0d3e6547b6d9aa572863e53916bd64fa2cacb2ce7921cc26b56459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d56386b58f24ea34caaa018b2c91c3d6f80b2e83d1c025b929553e5ae73738f"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "autoreconf", "--install"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use a U2F key for PAM authentication, specify the full path to the
      module (#{opt_lib}/pam/pam_u2f.so) in a PAM
      configuration. You can find all PAM configurations in /etc/pam.d.

      For further installation instructions, please visit
      https://developers.yubico.com/pam-u2f/#installation.
    EOS
  end

  test do
    system bin/"pamu2fcfg", "--version"
  end
end
