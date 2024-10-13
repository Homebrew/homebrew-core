class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-src.zip"
  sha256 "4c1100f5170ae1c3bd1b4fd9458b3b02ae841aefbfc41514887b80996436dee2"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  livecheck do
    url "https://premake.github.io/download/"
    regex(/href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3bfc9dcaa66a02d7a66b6dfe7ea26c30051bced4c021f213f918defb1400daa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c98ca72530e48dbdc33ccb631a81beee53314e93d6f5312684472ac9175306a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c0e198ec64df063c624729b362aeffcf03b6a7c3d369a289553830aa84e76e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a2d677314bd928dbbe53c160bd3d67477b485904f7df4afe1e7d92876380d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb6aded02913a669e7bb98a1556c1c1d069ca998e41c22fb77da2bafb82baa75"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad3de1154f1003e538a26acb07434550db8b66d9050c14416cc33bde88e16185"
    sha256 cellar: :any_skip_relocation, ventura:        "2e6089750d30a7173fd03d1c0397188f0bc81def52bd14d78c52b062d269a245"
    sha256 cellar: :any_skip_relocation, monterey:       "1e2e64dcda1ad406434262658bca0830bd564a6c8fc9878bad0178e807fc140d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0468917acf8072ff58035d030cff0500de669c64445bf113740d65d5cc098bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df19de0950ff6c2e808f5faf472ef74b52b68076c12ed4db4afe7ed9583c514b"
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
