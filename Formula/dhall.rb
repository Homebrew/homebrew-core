class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.40.1/dhall-1.40.1.tar.gz"
  sha256 "21c23ed7c3949f6c8adb439666a934460a07636320ae4b3dfaced03455e24e54"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af427f1180f96b9bcd9ff77347f861d19ac67b3b62e3511ffc0c1cb810483143"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1c36be171b91a50d710af00cd7321d6fadb496a90583f73e6033e28035a143e"
    sha256 cellar: :any_skip_relocation, catalina:      "ade8c77d54c09576a75f0e2f6bc98e0a2b7cceb4cf3e93c271a24258a3855e74"
    sha256 cellar: :any_skip_relocation, mojave:        "66ddeb565cc75a33877d69553b1aba1724a3a54e780954f799a45c3c5634ab82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c6a0b5b4c1a5901808d503625e0dee108fc221c23c049263dfb544699840a57"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
