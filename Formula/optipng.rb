class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.7/optipng-0.7.7.tar.gz"
  sha256 "4f32f233cef870b3f95d3ad6428bfe4224ef34908f1b42b0badf858216654452"
  head "http://hg.code.sf.net/p/optipng/mercurial", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "d83cda40bfd6ed17817b03196833819706ee96cbde994a3dbe08f82fc192a704" => :high_sierra
    sha256 "543c99a516e8a869b2957d41caa9c4e7b43ec6f77d412f7d7dba711c46ddeb9d" => :sierra
    sha256 "3a66cd2c1ccb98212213a2d0fcf2ba060a819d2ec504ba8a171a331f478162e8" => :el_capitan
  end

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/optipng", "-simulate", test_fixtures("test.png")
  end
end
