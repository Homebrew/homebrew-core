class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.3/hfst-ospell-0.5.3.tar.bz2"
  sha256 "01bc5af763e4232d8aace8e4e8e03e1904de179d9e860b7d2d13f83c66f17111"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5314d28a778d6de8ab6b65101bade00515431c3416edd2da9e13255c5b7b4d87"
    sha256 cellar: :any,                 arm64_big_sur:  "226621aba0afcb9a7a23e65b7af3c73369e6eca5ccd80f452effac5b8ce618c4"
    sha256 cellar: :any,                 monterey:       "283661bedee8725b2e6d6644135c7c1496b52b3b2c55132f5e4d4d73ad91d341"
    sha256 cellar: :any,                 big_sur:        "be7e07d571a2094bbd9c0d86defa90f7132a090e53c21b6bc4ae895b83b41321"
    sha256 cellar: :any,                 catalina:       "842b60f97791b893cdac47ce6b02e25c498f76bfff30aa1e0c7f2c7496ce2c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c4748cd6148ace09310e44959b0af790174f125735cd9a523c68606520ca92"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
