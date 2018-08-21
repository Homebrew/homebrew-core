class Libdaemon < Formula
  desc "C library that eases writing UNIX daemons"
  homepage "http://0pointer.de/lennart/projects/libdaemon/"
  url "http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz"
  sha256 "fd23eb5f6f986dcc7e708307355ba3289abe03cc381fc47a80bca4a50aa6b834"

  bottle do
    rebuild 1
    sha256 "385ec66344c5e84357e4e5caaf8441d914f3853cb60cd673c03b9521fa72647c" => :mojave
    sha256 "ef99499ba07c5d7e633071441933000b7da731db8e1c884e89cc3b484487a696" => :high_sierra
    sha256 "5a0acd70817e89a53d3c1855ab6f2d46911f1e5c284f05f187671fd4365879d1" => :sierra
    sha256 "d37febee18ba355a3d536c50dec03c51cb9cabb43cc76859ee2a772f6545e9f3" => :el_capitan
    sha256 "48de2498d199a800418e557b7fa70c5834094a60b76936d2541e0e242ffc25ec" => :yosemite
    sha256 "107d695ff51e515e6b8eb1c619a51efea5006d2df8d0dc5b0d32873994b3f936" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
