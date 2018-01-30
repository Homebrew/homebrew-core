class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/1.2.1/log4cplus-1.2.1.tar.xz"
  sha256 "09899274d18af7ec845ef2c36a86b446a03f6b0e3b317d96d89447007ebed0fc"

  bottle do
    cellar :any
    sha256 "e41ba73cf7b64b87432a2669e2aa724f751bd36262d18b56a29e1ddd557b3f2b" => :high_sierra
    sha256 "7e842fafbdeacd4cad0c7b806e151d521607fe953e5c674eee0e8dfb9fd31165" => :sierra
    sha256 "d051d31f4d76a18a70f21d10b3037e3fdad202d18acedbb158874f26a57ec104" => :el_capitan
    sha256 "47cbed5a69741494a419d04bebfe8755172f98d8cb66cc228174529630321373" => :yosemite
    sha256 "c60007704e699c4baeabad262b9600e5d0b8d8e217588c6e69f429b5f60d876d" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
