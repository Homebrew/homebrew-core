class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v2.1.10.tar.gz"
  sha256 "d7ed402bd79d4c219ee6a30ae52c9d788812271c23e96fe633837f8c3c630181"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "3f0fd81d568678badd6e4953fba86a6e010741381e33a8eebeb94ed23f6b58af"
    sha256                               arm64_ventura:  "02ab877ea13f764a66050f2ffb8cb5b9dbbbaef6ea4ad8f925f0982cc44dd55a"
    sha256                               arm64_monterey: "7ce25fe862f403b478e0d6327ba7a3e3984c853d984a3f4f094b6a8badbcb39b"
    sha256                               sonoma:         "3ae6cc39c8e7960df83222deda23a6bbb0fe5b09de46138caadd070776c0e06b"
    sha256                               ventura:        "61ef1f693961155ce13134e2c7217bd5f935e70175c8a942ebb8b30c50d3e05f"
    sha256                               monterey:       "9c6ecc14cc2bc8368c5e7c6482d7d11c9f8b220487a1bc4e9eb429ed48c7ec99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96b52ea33a8720111cf1db08dcb221194b836cdf96218d3260305cb5d32c64b5"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

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
