class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.3.tar.gz"
  sha256 "b842d6d49d423f7e234674678e9a107aa7b77e95b480677b020ee61dd160b2e3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89dfd9f7741028336512626fe08a64e0b60611978425d2114bb0847e52249238"
    sha256 cellar: :any,                 arm64_big_sur:  "d6311e4481c2b8b65c911bf24c42851557cdbd75801f92cf279b304953a2752a"
    sha256 cellar: :any,                 monterey:       "c721706515d601e7ea11833a75722277631e05261b9ba415bc17aa302183e674"
    sha256 cellar: :any,                 big_sur:        "6e61b636105463514c06a1a85b69fc5c6a6820ca37c52bd77d9183ef43c18048"
    sha256 cellar: :any,                 catalina:       "c9f8e8e0e6f50ee007996a837d369fd86a420d3b33ad96f93147e33b2c9e8b2a"
    sha256 cellar: :any,                 mojave:         "673f0150f56426a6218d02743c1b3ed3e564a0bb454d335eda0f1795dd513dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68479dd084bd4a06ccba9a64756904b6ffea34d49acb93384371778b316ae07e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version")
  end
end
