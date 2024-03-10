class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.7.tar.gz"
  sha256 "5f5ed0f136b678457834eb71226fc639b96bb34c61c110780ad97a4a44f8cf3a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "315132413f54797fa5c364676b0e5409e8427b25aabb6ad8df6878b99734c6d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "315132413f54797fa5c364676b0e5409e8427b25aabb6ad8df6878b99734c6d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "315132413f54797fa5c364676b0e5409e8427b25aabb6ad8df6878b99734c6d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "896817e362c32a0b97d169f7a6a6ae85ec8ba8fe91c9082020299e28232a6794"
    sha256 cellar: :any_skip_relocation, ventura:        "896817e362c32a0b97d169f7a6a6ae85ec8ba8fe91c9082020299e28232a6794"
    sha256 cellar: :any_skip_relocation, monterey:       "896817e362c32a0b97d169f7a6a6ae85ec8ba8fe91c9082020299e28232a6794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94f6b3a702610a1b718a177a1783b8cbe734bcb3053518af6662aecf1c698e5a"
  end

  depends_on "go" => :build

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
