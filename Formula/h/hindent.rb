class Hindent < Formula
  desc "Haskell pretty printer"
  homepage "https://github.com/mihaimaruseac/hindent"
  url "https://github.com/mihaimaruseac/hindent/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "9f3dcd310b5ef773600551af9eda8db40f69ffd570d8ed474f7b8c2e93cd55ec"
  license "BSD-3-Clause"
  head "https://github.com/mihaimaruseac/hindent.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f18ed01446a282c5a45a1dc27587c1f23de3fd5bf79c2e16894f3bee21012a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df0e64d7e7f95bb8db73c8fd210caef819e13b833a5e5916b0e9268c5648c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af07d6596d2ed1c545188526c22d66ad15a49f25044e2581592312d81e6797f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d66526b97f7fb1f4e99de9024f51a080099281a5c5900590bc469f166a2a4bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42766c8e3e09c699c48d2e27b5814e709975f6c1a16df0c576e72253ef18a7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf3e51687afa14afc64e1aec02272666e4bb95c197e34b5b6592eb220ecd079"
  end

  depends_on "cabal-install" => :build
  # TODO: switch to ghc@9.12 in the next release
  # https://github.com/mihaimaruseac/hindent/pull/1000
  # See GHC 9.14 issue: https://github.com/mihaimaruseac/hindent/issues/1155
  depends_on "ghc@9.10" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hindent --version")

    (testpath/"Input.hs").write <<~HASKELL
      example = case x of Just _ -> "Foo"
    HASKELL
    (testpath/"Expected.hs").write <<~HASKELL
      example =
        case x of
          Just _ -> "Foo"
    HASKELL

    assert_equal (testpath/"Expected.hs").read,
      pipe_output("#{bin}/hindent --indent-size 2", (testpath/"Input.hs").read, 0)
  end
end
