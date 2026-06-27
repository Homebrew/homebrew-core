class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/archive/refs/tags/v5.0.0-beta8.tar.gz"
  sha256 "2a55195fd2b27e5aa3de8ff6d22cdb127232a86f801d06e7f673d30a0eba09ac"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  livecheck do
    url "https://premake.github.io/download/"
    regex(/href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8208d6a888a07776ef2783f9922722bd447d0c0a670d6589b6c4d8f59b3cead3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ccbee7007446621865c016ee7ee0ee72291ef2403ea07b681bf11de23e0ce0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2165155556cf361ecb838b0672f170123f76d8f9aef457f18591ad4f551e7f36"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aa1523add5b5ea2bfd9fbf80baa237a41e120bbd38a625507281afbbe52795e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b35d7adbc0ef9d17faeb7838b5a00b53889708a3705b833ada04288049db1b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01caf266ed92e54b10c818c032ef8546def23020d74c784133bf3f713be683ba"
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
