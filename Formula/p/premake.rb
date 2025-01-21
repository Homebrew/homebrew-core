class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/releases/download/v5.0.0-beta4/premake-5.0.0-beta4-src.zip"
  sha256 "7ed887b3731ef6454b7c1cf99adbecb77f1abee088d0478916db8a4da16a1e82"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  livecheck do
    url "https://premake.github.io/download/"
    regex(/href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "881991a8f92bae6785d61fa135b75cbf2167f72dea81dc69e988f82584a34650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af776f3b2b25129f1e76ea56f2f595563300c7a3aba8a15325e360e5dbe979b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d0b3e94a3622f3b5cf93055810dfd4c347e8d882709e0b3a734a1620d20230d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7e7485f8685afe2c9614ae25632fa7578e843a96e4aee68f1c071fd667d75be"
    sha256 cellar: :any_skip_relocation, ventura:       "31b4dea50eff685369daec416ac307a59c112ddc2b790cb841c5b37eb5ac3463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e288f6bdf196560a2b12e270ad36b3fc760c57d5badf44296643e03cb1110c8"
  end

  on_linux do
    depends_on "util-linux" # for uuid
  end

  def install
    # Fix compile with newer Clang
    # upstream issue, https://github.com/premake/premake-core/issues/2092
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    if build.head?
      platform = OS.mac? ? "osx" : "linux"
      system "make", "-f", "Bootstrap.mak", platform
      system "./bin/release/premake5", "gmake2"
      system "./bin/release/premake5", "embed"
      system "make"
    else
      platform = OS.mac? ? "macosx" : "unix"
      system "make", "-C", "build/gmake2.#{platform}", "config=release"
    end
    bin.install "bin/release/premake5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/premake5 --version")
  end
end
