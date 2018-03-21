class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  url "https://swift.im/downloads/releases/swift-4.0/swift-4.0.tar.gz"
  sha256 "50b7b2069005b1474147110956f66fdde0afb2cbcca3d3cf47de56dc61217319"

  bottle do
    sha256 "7fad4a62d37b43fade07734f26864bc3b71f32a4e6809fc91ac079483bd1a3ec" => :high_sierra
    sha256 "0bec243071c491fc01ba04f7d2f5c01897ac004f18ffb3d67e77c87a56a364c3" => :sierra
    sha256 "3fd70667904b41f02676b117380dff2903ee9f5418d487fa0ed26fdc268b2be2" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libidn"
  depends_on "lua@5.1" => :recommended

  deprecated_option "without-lua" => "without-lua@5.1"

  def install
    boost = Formula["boost"]
    libidn = Formula["libidn"]

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
    ]

    if build.with? "lua@5.1"
      lua = Formula["lua@5.1"]
      args << "SLUIFT_INSTALLDIR=#{prefix}"
      args << "lua_includedir=#{lua.include}/lua-5.1"
      args << "lua_libdir=#{lua.lib}"
      args << "lua_libname=lua.5.1"
    end

    args << prefix

    scons *args
  end

  test do
    system "#{bin}/swiften-config"
  end
end
