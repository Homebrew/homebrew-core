class Optipng < Formula
  desc "PNG file optimizer"
  homepage "http://optipng.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.6/optipng-0.7.6.tar.gz"
  sha256 "4870631fcbd3825605f00a168b8debf44ea1cda8ef98a73e5411eee97199be80"
  head "http://hg.code.sf.net/p/optipng/mercurial", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "d5f0a362fc4d8821b73be6767b401bced46b897ef36d56881a10070fb3c07d88" => :el_capitan
    sha256 "2622e60d2f9313b39d2b385e84727e615839d6d531e4c6c7210a53b9cb584f61" => :yosemite
    sha256 "dd532d23f812dbc28b8f32171423946ee6fcfe87eab28665e7b484c83fc55e0e" => :mavericks
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
