class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "9c9b94bcdcf1cd0a899b24e1d3e18c6269227512661631814c2ac820683e2ec8"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "5f70653f3f52eee2e06583ae6c94f1513960a82de425459e1df9dbb5256b4334"
    sha256                               arm64_ventura:  "8f41814eb28775d6c70d786576a89c897ce552d7cd2eeade5e6f916dde7be7bc"
    sha256                               arm64_monterey: "cc2b19dd4ba3a5b5039ed520381cd069d6491fc24872b732edae36d21a213045"
    sha256                               sonoma:         "9c2990b1e4bf9974589cddf265f1048d561516eea8f27c39ef457de110ed775d"
    sha256                               ventura:        "a8b9692888b1742f9a013ff81d9b1b2efcbfcdd3ed6a18ba27277a6946ee9ae0"
    sha256                               monterey:       "b60be490d338d5248687ece31ee3e383b4683bdbe61fe631845c895f8f216f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f150937225161029ed04a6c6490e7c8fbd579a9f856dea784125090c0d001c9a"
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
