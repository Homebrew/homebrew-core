class Cornelis < Formula
  desc "Neovim support for Agda"
  homepage "https://github.com/agda/cornelis"
  url "https://github.com/agda/cornelis/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "41787428319dbde15b51ce427451d4a48f14d54a7c42902d004458e232ca3022"
  license "BSD-3-Clause"
  head "https://github.com/agda/cornelis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3ab116742d0b8c90533803a535510040520b1a90d8e0b68e9a9d10fc6ca065af"
    sha256 cellar: :any,                 arm64_sequoia: "f539829b0e192eb0891a00b8a200ccf0e6c11002499662de544535214dbc3f2d"
    sha256 cellar: :any,                 arm64_sonoma:  "4a907e326af68978aa8c5a1bca6bc3f29557e7d94a5397a0ceff6b5a1e63468b"
    sha256 cellar: :any,                 sonoma:        "05c0bca472d34b3ab32a48d4e67005584e2be329c93996817029724ffb857547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "681e3180af2e1f4bd4c88f2ecaf47b73c5cf3999bfbe61fe9497bc3e618ebef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26837b1b79f08ab9ed366fd425cabec1d927cea8ba6d3355480c8e324be9476f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    expected = "\x94\x00\x01\xC4\x15nvim_create_namespace\x91\xC4\bcornelis"
    actual = pipe_output("#{bin}/cornelis NAME", nil, 0)
    assert_equal expected, actual
  end
end
