class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.31.10.tar.gz"
  sha256 "e15c301e7ee2a30407dad6941166260da233475d1058b60e8c8d07c6e65de92b"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af50945278237fdb74459c931af84ca3c9e0484f60d4509df05813283350db56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af50945278237fdb74459c931af84ca3c9e0484f60d4509df05813283350db56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af50945278237fdb74459c931af84ca3c9e0484f60d4509df05813283350db56"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc778156e324f72543f4350f41d7530dad39a0b77ec0a37c021979ad16adb78c"
    sha256 cellar: :any_skip_relocation, ventura:       "fc778156e324f72543f4350f41d7530dad39a0b77ec0a37c021979ad16adb78c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff20da9a0eb49ce75a94e8c476bbcc61bf37b903288d1a7fc15a511797adaff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2a226b8f6a1dffa3f84def07bb91295da7c360d9b43a50431719e1404a11511"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
