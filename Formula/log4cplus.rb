class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://github.com/log4cplus/log4cplus/archive/REL_1_2_1.tar.gz"
  sha256 "510c916194ea86f1cc47070e96981aa80f3ca5944544711c225d8bcf7283b2fc"

  bottle do
    cellar :any
    sha256 "b744574eb3dbc662c7143d2369feaef039c5a3959fb5ea8cdea5410efab7c3a5" => :high_sierra
    sha256 "f5f8ec470c5a4e1b0043ff44f85b8deda8ad27189f5766f330e60e162f7054c8" => :sierra
    sha256 "8819df40a1477a3fb87a4a3dcd36ec8e2292b5aed362851549e8e2df74ffad9d" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
