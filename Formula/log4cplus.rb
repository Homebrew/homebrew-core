class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/1.2.1/log4cplus-1.2.1.tar.xz"
  sha256 "09899274d18af7ec845ef2c36a86b446a03f6b0e3b317d96d89447007ebed0fc"

  bottle do
    cellar :any
    sha256 "b744574eb3dbc662c7143d2369feaef039c5a3959fb5ea8cdea5410efab7c3a5" => :high_sierra
    sha256 "f5f8ec470c5a4e1b0043ff44f85b8deda8ad27189f5766f330e60e162f7054c8" => :sierra
    sha256 "8819df40a1477a3fb87a4a3dcd36ec8e2292b5aed362851549e8e2df74ffad9d" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
