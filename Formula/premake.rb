class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
  sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7041f35efe50688277d179f0a7af80c7e29b10a8a328f561914001221370415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a101d1061eac5c40a487446d5ac89dd6e7ede28ca84384f0478872b1e0f5f187"
    sha256 cellar: :any_skip_relocation, monterey:       "6334247fc2a1a12f3b35950b53f4fb2c0116081efc3745d38e5c18218004b3e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "26aff9a75d01019428c486f14e2b4c0822d1b21530d6b093838308c176939aa5"
    sha256 cellar: :any_skip_relocation, catalina:       "cf128251e2798e7fd65919002b3adc627537c969dfaf62021ec6cd78fb7eeb12"
    sha256 cellar: :any_skip_relocation, mojave:         "b5fe3f9495148d2f374b048e72cfc3114be0195a9954d57c8c298fca568d2896"
    sha256 cellar: :any_skip_relocation, high_sierra:    "79e1f3b9c8ba609685ee343f2022aae2fb02cacecc84e44d817014fe7d3dabfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d2ba7e57d942fb6296be5d0a7ede7d1e7f21775e9479d926960d8b038d07751"
  end

  # See: https://groups.google.com/g/premake-development/c/i1uA1Wk6zYM/m/kbp9q4Awu70J
  deprecate! date: "2015-05-28", because: "premake4 is unsupported and premake5 is still alpha"

  def install
    if build.head?
      platform = if OS.mac?
        "osx"
      else
        "linux"
      end
      system "make", "-f", "Bootstrap.mak", platform
      system "./bin/release/premake5", "gmake2"
      system "./bin/release/premake5", "embed"
      system "make"
      bin.install "bin/release/premake5"
    else
      platform = if OS.mac?
        "macosx"
      else
        "unix"
      end
      system "make", "-C", "build/gmake.#{platform}"
      bin.install "bin/release/premake4"
    end
  end

  test do
    if build.head?
      assert_match "5.0.0-dev", shell_output("#{bin}/premake5 --version")
    else
      assert_match version.to_s, shell_output("#{bin}/premake4 --version", 1)
    end
  end
end
