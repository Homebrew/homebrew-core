class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  url "https://swift.im/downloads/releases/swift-4.0/swift-4.0.tar.gz"
  sha256 "50b7b2069005b1474147110956f66fdde0afb2cbcca3d3cf47de56dc61217319"

  bottle do
    sha256 "80f1c8958f7e87ed9a9f4cfc2ecbff11e33042d9ee6cb41ca84a76f10696243b" => :high_sierra
    sha256 "5dd9e842a516e65105150e427f2889a83445d13172bef73422be437f7557b98e" => :sierra
    sha256 "74466b9e1c89fece62dd092058ebe7b6fdb86bcfeef49c3e61a980e39cb2cf5a" => :el_capitan
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
