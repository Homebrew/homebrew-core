class Optipng < Formula
  desc "PNG file optimizer"
  homepage "http://optipng.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.6/optipng-0.7.6.tar.gz"
  sha256 "4870631fcbd3825605f00a168b8debf44ea1cda8ef98a73e5411eee97199be80"
  head "http://hg.code.sf.net/p/optipng/mercurial", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "41a2a04cfa3a8a39292157a4410a345236747a5e3c992c58e2cf364d2ed0dd9b" => :sierra
    sha256 "b062317980451b8a6a129e87f3a22ae851e42c498775a9c5a0e885d265425450" => :el_capitan
    sha256 "a8b8c3682ae147ff68f37db1155ecd86c965e6e5c4fc0e20b0da3297060cbea2" => :yosemite
    sha256 "64e1d9fd2a5dd56a91af23ab2a170f68fa06993b2b1ed539b17ffad086e1e28f" => :mavericks
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
