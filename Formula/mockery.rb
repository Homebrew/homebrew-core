class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "5c08b031322e843b14c08465699fca2afa06e5fe8a0da61bb572fa7122741da0"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaaf84f334efca08562441e64473df72bd25435e0706d18dafb334e18e687e6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e01f272d3dd4fd151742d7d6004cd4805afc536cca32df623b1f220f407292"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa394604e65d37c9efefb0d34b9629175961e875c2483817205f72439ff3632b"
    sha256 cellar: :any_skip_relocation, ventura:        "9cf3a607d2be0fe9aa7747370720aca9c1bfd0f1fd871cb340166581ac6df7b2"
    sha256 cellar: :any_skip_relocation, monterey:       "b89c726096b655b60abcc86344710aed92087e414c4e41071aa28e355c3e3793"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbc4bbd014308990c78822c6e6dfaad241db7c6f668ffc905a32f547f241a1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64cd384632f37bf6681331b11dd2d663b83e1900788c9cff14aa6e48a4422f7d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
