class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.7.tar.gz"
  sha256 "5f5ed0f136b678457834eb71226fc639b96bb34c61c110780ad97a4a44f8cf3a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94dfc010676ca06bb5618d896f20175d72bc005d056f775953268fba1f63dae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94dfc010676ca06bb5618d896f20175d72bc005d056f775953268fba1f63dae6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94dfc010676ca06bb5618d896f20175d72bc005d056f775953268fba1f63dae6"
    sha256 cellar: :any_skip_relocation, sonoma:         "541f13d7bd3ccc4dedf5fe9e82813ff0c479c00dbf6d7bf143f8837a50bb5d78"
    sha256 cellar: :any_skip_relocation, ventura:        "541f13d7bd3ccc4dedf5fe9e82813ff0c479c00dbf6d7bf143f8837a50bb5d78"
    sha256 cellar: :any_skip_relocation, monterey:       "541f13d7bd3ccc4dedf5fe9e82813ff0c479c00dbf6d7bf143f8837a50bb5d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e4ad4b486674f35490619eba1f6216da173d1768bd33c8135520ef401b0c0a"
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
