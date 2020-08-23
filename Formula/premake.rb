class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
  sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cf128251e2798e7fd65919002b3adc627537c969dfaf62021ec6cd78fb7eeb12" => :catalina
    sha256 "b5fe3f9495148d2f374b048e72cfc3114be0195a9954d57c8c298fca568d2896" => :mojave
    sha256 "79e1f3b9c8ba609685ee343f2022aae2fb02cacecc84e44d817014fe7d3dabfc" => :high_sierra
  end

  # See: https://groups.google.com/g/premake-development/c/i1uA1Wk6zYM/m/kbp9q4Awu70J
  deprecate! date: "2015-05-28"

  def install
    if build.head?
      system "make", "-f", "Bootstrap.mak", "osx"
      system "./premake5", "gmake"
    end

    system "make", "-C", "build/gmake.macosx"

    if build.head?
      bin.install "bin/release/premake5"
    else
      bin.install "bin/release/premake4"
    end
  end

  test do
    if build.head?
      assert_match version.to_s, shell_output("#{bin}/premake5 --version")
    else
      assert_match version.to_s, shell_output("#{bin}/premake4 --version", 1)
    end
  end
end
