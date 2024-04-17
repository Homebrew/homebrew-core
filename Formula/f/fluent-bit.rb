class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "d2bbf633ddaa79210db31a18c65feb81377d9e3ffca01c0f88fc68d2dfbb2661"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "4e3184a6a09a0cdf17d117175250f23d118dfd65b0b1cb8d88eaa2459d90e2b8"
    sha256                               arm64_ventura:  "433422259a8cb80b451bbda84544963cc7dd4ddb6d8cf2b796fc7a7ed45db884"
    sha256                               arm64_monterey: "5facc2f697311721b6773bb88fe8a02e09b4e3722dba89d87c96d7495acfedca"
    sha256                               sonoma:         "a187e1e6d28323bc48056d7fcae9fbc7c91e749a046fd7e491bcadf3e43eb94f"
    sha256                               ventura:        "75a599f11db318aec7bf0ec6460ae9ee683dc73b5798beff38c9f3021c50a45c"
    sha256                               monterey:       "0814b04deeac0fdd2ffb0e63ac97c1f3be32ca3b755a6f88014e07cf7eea220e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad4e372b3ee5cd19df7bdb52ba85b003c9a3a87566b43f49bf0893179951af9"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  # Avoid conflicts with our `luajit` formula.
  # We don't need to set LDFLAGS because LuaJIT is statically linked.
  patch :DATA

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end

__END__
--- a/lib/luajit-cmake/LuaJIT.cmake
+++ b/lib/luajit-cmake/LuaJIT.cmake
@@ -569,13 +569,13 @@ set(luajit_headers
   ${LJ_DIR}/luaconf.h
   ${LJ_DIR}/luajit.h
   ${LJ_DIR}/lualib.h)
-install(FILES ${luajit_headers} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/luajit)
+install(FILES ${luajit_headers} DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}/include/luajit)
 install(TARGETS libluajit
-    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
-    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
+    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}/lib
+    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}/lib)

 # Build the luajit binary
-if (LUAJIT_BUILD_EXE)
+if (FALSE)
   add_executable(luajit ${LJ_DIR}/luajit.c)
   target_link_libraries(luajit libluajit)
   if(APPLE AND ${CMAKE_C_COMPILER_ID} STREQUAL "zig")
