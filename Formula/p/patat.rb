class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.12.0.1/patat-0.12.0.1.tar.gz"
  sha256 "05f8de68743a042ae39751297d79440d6a7f2dce0f1fe01c00509269c272ea56"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b6e8110485667eab4131c96dc49960b36c27b337406553f5802102827ffdf16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3dff887ad63b71e6d97aeb02184a06291f9582abf38f6751810639ef273baf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c8e5aae38ee7b411ea898897a4c670b5e87b9b11bbb3a143900b192b186bf67"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be9b90ba35383cf164e4d562cbd1d52f16c569a32afcd6a7c95820f41537683"
    sha256 cellar: :any_skip_relocation, ventura:       "3285c88a72f780615d5817831a6aaa02f754660da19ccb3290dd48bdf4bb065a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead5e98838eeb3c8e49d9ca768dd313ce48b380b59dee5d93de71fb039802723"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~EOS
      # Hello from Patat
      Slide 1
      ---
      Slide 2
    EOS
    output = shell_output("#{bin}/patat --dump --force #{test_file}")
    assert_match "Hello from Patat", output

    assert_match version.to_s, shell_output("#{bin}/patat --version")
  end
end
