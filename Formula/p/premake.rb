class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/releases/download/v5.0.0-beta7/premake-5.0.0-beta7-src.zip"
  sha256 "d39874aed04e317a46bdd281b193fe58c70457cd07bbd50e1bdcb4729c3a4860"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  livecheck do
    url "https://premake.github.io/download/"
    regex(/href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zip/i)
  end

  on_linux do
    depends_on "util-linux" # for uuid
  end

  def install
    # Fix compile with newer Clang
    # upstream issue, https://github.com/premake/premake-core/issues/2092
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Fix to avoid fdopen() redefinition for vendored `zlib`
    if OS.mac? && DevelopmentTools.clang_build_version >= 1700
      inreplace "contrib/zlib/zutil.h",
                "#        define fdopen(fd,mode) NULL /* No fdopen() */",
                "#if !defined(__APPLE__)\n#  define fdopen(fd,mode) NULL /* No fdopen() */\n#endif"
    end

    platform = OS.mac? ? "osx" : "linux"
    system "make", "-f", "Bootstrap.mak", platform
    system "./bin/release/premake5", "gmake2"
    system "./bin/release/premake5", "embed"
    system "make"
    bin.install "bin/release/premake5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/premake5 --version")
  end
end
