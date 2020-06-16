class Premake5 < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha15/premake-5.0.0-alpha15-src.zip"
  sha256 "880f56e7cb9f4945d1cb879f059189462c1b7bf62ef43ac7d25842dfb177dd53"

  def install
    system "make", "-f", "Bootstrap.mak", "osx"
    bin.install "bin/release/premake5"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>

      int main(void) {
        puts("Hello, world!");
        return 0;
      }
    EOS

    (testpath/"premake5.lua").write <<~EOS
      workspace "HelloWorld"
        configurations { "Debug", "Release" }

      project "HelloWorld"
        kind "ConsoleApp"
        language "C"
        targetdir "bin/%{cfg.buildcfg}"

        files { "**.h", "**.c" }

        filter "configurations:Debug"
          defines { "DEBUG" }
          symbols "On"

        filter "configurations:Release"
          defines { "NDEBUG" }
          optimize "On"
    EOS

    system bin/"premake5", "gmake"
    system "make", "config=release", "verbose=1"
    assert_match "Hello, world!", shell_output("bin/Release/HelloWorld").strip
  end
end
