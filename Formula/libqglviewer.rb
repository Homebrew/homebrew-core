class Libqglviewer < Formula
  desc "C++ Qt library to create OpenGL 3D viewers"
  homepage "http://www.libqglviewer.com/"
  url "http://www.libqglviewer.com/src/libQGLViewer-2.6.4.tar.gz"
  sha256 "53daefd7981a3ff7719ee55c368226807791d916ed988dde0aa0eac89686389d"
  head "https://github.com/GillesDebunne/libQGLViewer.git"

  bottle do
    cellar :any
    sha256 "1f00c73ef441a6ffcddd7a4b086701b4a56796c4b9fd6ca979f0cbc7e485c97e" => :el_capitan
    sha256 "ee30fec03b3a34c4377211779212bae6f0bf1211b20abed235ef2503b5b72d9c" => :yosemite
    sha256 "8bb883a52487feb86cd2bbe1c83ac4c70a7d45282ef76a4a22e7dfa89774d9f8" => :mavericks
  end

  option :universal

  depends_on "qt5"

  def install
    args = %W[
      PREFIX=#{prefix}
      DOC_DIR=#{doc}
    ]
    args << "CONFIG += x86 x86_64" if build.universal?

    cd "QGLViewer" do
      system "qmake", *args
      system "make", "install"
    end
  end
end
