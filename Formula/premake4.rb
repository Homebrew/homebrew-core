class Premake4 < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
  sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"
  version_scheme 1

  def install
    system "make", "-C", "build/gmake.macosx"
    bin.install "bin/release/premake4"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>

      int main(void) {
        puts("Hello, world!");
        return 0;
      }
    EOS

    (testpath/"premake4.lua").write <<~EOS
      solution "HelloWorld"
        configurations { "Debug", "Release" }

      project "HelloWorld"
        kind "ConsoleApp"
        language "C"

        files { "**.h", "**.c" }

        configuration "Debug"
          defines { "DEBUG" }
          flags { "Symbols" }

        configuration "Release"
          defines { "NDEBUG" }
          flags { "Optimize" }
    EOS

    system bin/"premake4", "gmake"
    system "make", "config=release", "verbose=1"
    assert_match "Hello, world!", shell_output("./HelloWorld").strip
  end
end
