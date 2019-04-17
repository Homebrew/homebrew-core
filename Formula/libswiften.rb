class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  url "https://swift.im/downloads/releases/swift-4.0/swift-4.0.tar.gz"
  sha256 "50b7b2069005b1474147110956f66fdde0afb2cbcca3d3cf47de56dc61217319"
  revision 3

  bottle do
    cellar :any
    sha256 "822a8010f7ec2bf10e19eb45970729fd3676086b01980881b4a88b5f881d33c2" => :mojave
    sha256 "bcdb2fec93af1b9bc7e3c914e0c0bb9530b3869a4fe8a54572468f48107bc945" => :high_sierra
    sha256 "aeac54677158c71e559b0db7f85895ce5e2b54f2b0a0e566638c568848f2fe1f" => :sierra
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
