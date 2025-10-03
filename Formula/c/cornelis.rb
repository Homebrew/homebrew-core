class Cornelis < Formula
  desc "Neovim support for Agda"
  homepage "https://github.com/agda/cornelis"
  url "https://github.com/agda/cornelis/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "41787428319dbde15b51ce427451d4a48f14d54a7c42902d004458e232ca3022"
  license "BSD-3-Clause"
  head "https://github.com/agda/cornelis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "103d80490d25947c1dd3d7161b76f5b5a63845afc8c961a8d9664cc61a5d3f90"
    sha256 cellar: :any,                 arm64_sequoia: "bf400828f83abba48acb6c2ec8e25ed1e96917c925f213ab6d39c4113a53409b"
    sha256 cellar: :any,                 arm64_sonoma:  "d25401f92c4d9d180780f1230eb0ccf39b1b80974f12b9d248392e4a3aeea090"
    sha256 cellar: :any,                 arm64_ventura: "6ec7c5adf4a3de1e3f1bb14c16b8331a5ddea0e53e89e6a4fdfb3a7d9ee1acba"
    sha256 cellar: :any,                 sonoma:        "a8a253190ca8160a77009bd98428a911e7b1744347a5cb3064425b1a82bb3ac6"
    sha256 cellar: :any,                 ventura:       "424458fd634c9cba6e292d05a251d1bee0ec1d7b877c833f41604f557d6f7b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c535f472a6eee69b4e10dab39e5907adc21ee787b494863bc6f8b5bbcc83bb88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99250a940957d3ed12ff7037381f5b1a2599a479d2a4900327f01f0e42bc81f0"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", ".", *std_cabal_v2_args
  end

  test do
    expected = "\x94\x00\x01\xC4\x15nvim_create_namespace\x91\xC4\bcornelis"
    actual = pipe_output("#{bin}/cornelis NAME", nil, 0)
    assert_equal expected, actual
  end
end
