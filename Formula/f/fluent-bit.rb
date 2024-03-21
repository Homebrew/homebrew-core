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
    sha256                               arm64_sonoma:   "91249e76a6d1feeabd0247f496731221d42b4bfdc7b32c4df75b03225e3932ce"
    sha256                               arm64_ventura:  "0e4e2059b77cc3b697acc6aecf06efdc7e31b9207076a7bfea1a49f96e923086"
    sha256                               arm64_monterey: "57f6a1ea369ad8fb070fb795be53ecac160c73b23e96d55d4dd2ca75f54b688c"
    sha256                               sonoma:         "6fd10666467502631c82e28ee06ff345a9afcd26ab9f7d616c4fa9fc83a4418c"
    sha256                               ventura:        "6707fc978f09384e95fcc6267f5f1d5448b2d0c9eaec6feee2a8a057550604a9"
    sha256                               monterey:       "72d98872c98f0aa8ec31ecc1f6d1730b1563c66a65ed3f66c0b6d776a3b30e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "838073001f1da9f18a7971cca2231c9593652a4c3cb6988ff7b9f9b0b860d1c2"
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
