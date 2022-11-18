class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-608.tar.gz"
  sha256 "a69abe2e0a126777e021d3b73aa3222e1b261f10e64624d41ec079685a6ac209"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "390f1b4652817cd10840047fced9f4accc4854ac1b4c8eaf70edcf7a63f291e5"
    sha256 cellar: :any,                 arm64_monterey: "0c111d7d5f231c4b409d4e6441ebb1cfc40bdf440c1bd7d6fff11b1e16adfc31"
    sha256 cellar: :any,                 arm64_big_sur:  "ecc9669f294fd8d3826f3c513590387a2dd37a248d4bd827c8301d857bf6cfa4"
    sha256 cellar: :any,                 ventura:        "031ad93faffc4dad178a2708c638f6bf1c22609669006b06705221c75a152022"
    sha256 cellar: :any,                 monterey:       "b5cf2d6c6e1a6c23d9086323c4363a022e1e2264dd4f0e1a287396beb88edced"
    sha256 cellar: :any,                 big_sur:        "2d40fdc792b4aee7bc4016cb1daf3c14708c7f90f464fb49a5dd6f6f659809e8"
    sha256 cellar: :any,                 catalina:       "5a785fbf1ac017df8814d9b86cd0fcdbacfdc4159e80da7ea738b1944cd1e9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98769ef6e7ed3f87c9d90bf73666693fea66ebd91434a7e5b2982f7b8ef55244"
  end

  head do
    url "https://github.com/gwsw/less.git"
    depends_on "autoconf" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
