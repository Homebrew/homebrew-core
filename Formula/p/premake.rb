class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/archive/refs/tags/v5.0.0-beta7.tar.gz"
  sha256 "51c01a1bb48de2bc98c025afd4eeade0059376785337725da7ee323a79e862f0"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  livecheck do
    url "https://premake.github.io/download/"
    regex(/href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ccc181473bc0e451fd18ab092b9368df944732b22c7ceb5b05959745f46726c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfff1c114f920748e70d7a2d66b318ca7abc5a214d15bceaed8c1a0b6f0ab65e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddf0a5e8d1f32c3eff0894a526d3dfef15abec064a0edc1d655ef5d4b05f2c80"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bbf1f0319f1eec1b39a97f1932503b7b09afc333bbb717372c1d372f65d7fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2e4a5174414175e12d206eb5f6c813e0c56db30d9cdb728f118ce798730b70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0443fb4f99c85c972356f8a123b3ef369c86cfeef497d26acb8e3f983ec6f58"
  end

  on_linux do
    depends_on "util-linux" # for uuid
  end

  def install
    platform = OS.mac? ? "osx" : "linux"
    system "make", "-f", "Bootstrap.mak", platform
    system "./bin/release/premake5", "gmake"
    system "./bin/release/premake5", "embed"
    system "make"
    bin.install "bin/release/premake5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/premake5 --version")
  end
end
