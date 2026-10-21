class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "ed52d17463112d6b93bc6e34bb6e15c6332e1f313ad5259fdde60e270aa30aec"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb3a10cd4d06c6a765e9420c9e96093328401a9e3396d443942931b55f78ce5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab86f4550238dccd1dc4bf648add5bb9e8115f326306bf30058e015f165c409d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72788f973fac2ecec163b6489253ff21c990d4aa710f1cd272c6a94f6b968af2"
    sha256 cellar: :any,                 arm64_linux:       "11eefadb7a7d317a294614c48374a2c02c635202439d147622f250d87f77b1da"
    sha256 cellar: :any,                 x86_64_linux:      "09b1c4d00cab87ccda6448c3665d06314914a9a24038343f32ba2d33c008e60c"
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
