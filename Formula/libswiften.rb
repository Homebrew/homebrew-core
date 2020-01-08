class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  url "https://swift.im/downloads/releases/swift-4.0/swift-4.0.tar.gz"
  sha256 "50b7b2069005b1474147110956f66fdde0afb2cbcca3d3cf47de56dc61217319"
  revision 4

  bottle do
    cellar :any
    sha256 "919e570b27576a942a2dd08c190f188cf8f0deb00950dc0b5956478da38091ed" => :catalina
    sha256 "489821c365b23676ac84c6f9ecc2157edaebd6d0025fa75b5f5e972078dead88" => :mojave
    sha256 "3ec7dc4286e4651d14188794f22d4d89fa1284b999c7134416abcdd02d880744" => :high_sierra
    sha256 "07e2d9467520a4c814e15b5328bec8b989449284161c66e120b036f09eed8d14" => :sierra
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libidn"
  depends_on "lua@5.1"

  # fix build for boost 1.69
  patch do
    url "https://swift.im/git/swift/patch/?id=3666cbbe30e4d4e25401a5902ae359bc2c24248b"
    sha256 "483ace97ee0d0c17a96f8feb7820611fdb1eca1cbb95777c36ca4fad0fdef7f9"
  end

  # fix build for boost 1.69
  patch do
    url "https://swift.im/git/swift/patch/?id=a2dc74cd0e4891037b97b6a782de80458675e4f0"
    sha256 "28fa8bfdd5b3ec45c00cab8a968ac1528846bbc5a2e3eeeaaaef83785b42bb7f"
  end

  def install
    boost = Formula["boost"]
    libidn = Formula["libidn"]
    lua = Formula["lua@5.1"]

    args = %W[
      -j #{ENV.make_jobs}
      V=1
      linkflags=-headerpad_max_install_names
      optimize=1 debug=0
      allow_warnings=1
      swiften_dll=1
      boost_includedir=#{boost.include}
      boost_libdir=#{boost.lib}
      libidn_includedir=#{libidn.include}
      libidn_libdir=#{libidn.lib}
      SWIFTEN_INSTALLDIR=#{prefix}
      openssl=no
      SLUIFT_INSTALLDIR=#{prefix}
      lua_includedir=#{lua.include}/lua-5.1
      lua_libdir=#{lua.lib}
      lua_libname=lua.5.1
      #{prefix}
    ]

    system "scons", *args
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Swiften/Swiften.h>
      using namespace Swift;
      int main()
      {
        SimpleEventLoop eventLoop;
        BoostNetworkFactories networkFactories(&eventLoop);
        return 0;
      }
    EOS
    cflags = `#{bin}/swiften-config --cflags`
    ldflags = `#{bin}/swiften-config --libs`
    system "#{ENV.cxx} -std=c++11 test.cpp #{cflags.chomp} #{ldflags.chomp} -o test"
    system "./test"
  end
end
