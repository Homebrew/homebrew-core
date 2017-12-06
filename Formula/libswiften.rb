class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  revision 2
  head "https://swift.im/git/swift"

  stable do
    url "https://swift.im/downloads/releases/swift-3.0/swift-3.0.tar.gz"
    sha256 "8aa490431190294e62a9fc18b69ccc63dd0f561858d7d0b05c9c65f4d6ba5397"

    # Patch to fix build error of dynamic library with Apple's Secure Transport API
    # Fixed upstream: https://swift.im/git/swift/commit/?id=1d545a4a7fb877f021508094b88c1f17b30d8b4e
    patch :DATA
  end

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
    inreplace "Sluift/main.cpp", "#include <string>",
                                 "#include <iostream>\n#include <string>"

    inreplace "BuildTools/SCons/SConstruct",
              /(\["BOOST_SIGNALS_NO_DEPRECATION_WARNING")\]/,
              "\\1, \"__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0\"]"

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

__END__
diff --git a/Swiften/TLS/SConscript b/Swiften/TLS/SConscript
index f5eb053..c1ff425 100644
--- a/Swiften/TLS/SConscript
+++ b/Swiften/TLS/SConscript
@@ -20,7 +20,7 @@ if myenv.get("HAVE_OPENSSL", 0) :
	myenv.Append(CPPDEFINES = "HAVE_OPENSSL")
 elif myenv.get("HAVE_SCHANNEL", 0) :
	swiften_env.Append(LIBS = ["Winscard"])
-	objects += myenv.StaticObject([
+	objects += myenv.SwiftenObject([
			"CAPICertificate.cpp",
			"Schannel/SchannelContext.cpp",
			"Schannel/SchannelCertificate.cpp",
@@ -29,7 +29,7 @@ elif myenv.get("HAVE_SCHANNEL", 0) :
	myenv.Append(CPPDEFINES = "HAVE_SCHANNEL")
 elif myenv.get("HAVE_SECURETRANSPORT", 0) :
	#swiften_env.Append(LIBS = ["Winscard"])
-	objects += myenv.StaticObject([
+	objects += myenv.SwiftenObject([
			"SecureTransport/SecureTransportContext.mm",
			"SecureTransport/SecureTransportCertificate.mm",
			"SecureTransport/SecureTransportContextFactory.cpp",
