class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  url "https://swift.im/downloads/releases/swift-4.0/swift-4.0.tar.gz"
  sha256 "50b7b2069005b1474147110956f66fdde0afb2cbcca3d3cf47de56dc61217319"
  revision 2

  bottle do
    sha256 "17b63d430ff948e007e772d2ea7703c285862c365dc91e8b4fa6d4deca809c3f" => :mojave
    sha256 "d6f72af74d50059da4be26ce6132b295e9644504214559b283261a6feb7261a3" => :high_sierra
    sha256 "6ec48b297dc04f2f4b544a760a3b05964d17e04ff3f5b37ffddc7b8aad5b031a" => :sierra
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libidn"
  depends_on "lua@5.1"

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

    scons *args
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
