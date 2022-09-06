class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.3/hfst-ospell-0.5.3.tar.bz2"
  sha256 "01bc5af763e4232d8aace8e4e8e03e1904de179d9e860b7d2d13f83c66f17111"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6de7d9025440009c2c87b1375592eb793811433198dde9801ff798f5fa69b16c"
    sha256 cellar: :any,                 arm64_big_sur:  "49232ba8c7574e62a7c73666fc9b5d9fef31836427a3f82c62577fe8b574d449"
    sha256 cellar: :any,                 monterey:       "fe864e0624035d668eb5f1d195eb37b8659ee09de8b25755a6e11ec0fffb625e"
    sha256 cellar: :any,                 big_sur:        "4d520153b42510bc5b35c6e43ae40b8e2977b12ce4ab6e2e916009496e1a6e60"
    sha256 cellar: :any,                 catalina:       "699018bb946b1ff47cfa36eb49cb4f82b304a6c00f28884058e5f207cc7e3688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01a8e9c15132bb6ad74327191e382d801e59538d02cb1dfa80ce02b4f8efb03"
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
