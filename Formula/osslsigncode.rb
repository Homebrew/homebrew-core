class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.3.tar.gz"
  sha256 "b842d6d49d423f7e234674678e9a107aa7b77e95b480677b020ee61dd160b2e3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1548079408eb4af20b65cd3e139670cb0cf2b13a5479e54858d2f2bd11b0fda1"
    sha256 cellar: :any,                 arm64_big_sur:  "8761a83191bdd8dff87f0e516bf62fa050d6934dc21d6e8babc05278582c5637"
    sha256 cellar: :any,                 monterey:       "f297b56522de080dbab85a8205655a3abdb1bd5e83c410d16c8972ed75e355dc"
    sha256 cellar: :any,                 big_sur:        "89c13c082ebd82eb6fa9ecb007b759b9159d270542666ad2f383e90627c501a4"
    sha256 cellar: :any,                 catalina:       "bd1a562399486c6f212ec5c61562bd0f53ffb08224778c76fd787d07900920fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2549903650fdd0189c1083a177af1c789364758080828b8ea6cf46c376ed6d65"
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
