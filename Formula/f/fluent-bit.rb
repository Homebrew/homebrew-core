class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "e70ae5be2f0ca1cb842a1c8d2762437907c522765f79b5c0c391eaa1b57c9f4c"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "ecba0ec4c8de9833b746d04c4e3e3c1d92e084ff0b739a877741a545c68f4848"
    sha256                               arm64_ventura:  "978a188b2a3e0ab88a0be966691ecea45e57aa3f6171eab0ef2a43ce2c8d4c46"
    sha256                               arm64_monterey: "72f4fe3f35c0f9534b506e359d7fa0acfb98b7333b0498eb018d03a8650b985c"
    sha256                               sonoma:         "09c14bbc2a363589f5234efd071b10ef498dc34626da7611d7f4f0a8638a3bee"
    sha256                               ventura:        "25ce1469530d5b2661cbc76b112d0b6e913457f718d2ed7ea617e782abcfc371"
    sha256                               monterey:       "33fbf95387365795bc2e411b119912a6b135b722c02b251ca0cfac0cd6e2117e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b05b5d7f1beb6198e70514b74f80f5c10da1c41affde1350612beba8d8b91871"
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
