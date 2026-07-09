class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.1.1.tar.gz"
  sha256 "20b551a912f9d849d3f697fafcacb3edc7cc87037fc3847dca5d4e260a5be014"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fbf74701a04c1d06cc239d818e0be413e88c2769c5277c35b6d3612a1b86380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fbf74701a04c1d06cc239d818e0be413e88c2769c5277c35b6d3612a1b86380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fbf74701a04c1d06cc239d818e0be413e88c2769c5277c35b6d3612a1b86380"
    sha256 cellar: :any_skip_relocation, sonoma:        "a11f716195756e42b244f7356152477ab630d6385715ef3d098b2d0c5c15f6db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "820e729ef186c6a7d9f4907fdf70a916b0b683593c53e158fb8e93e0e9efd977"
    sha256 cellar: :any,                 x86_64_linux:  "d54ee73974e8cd395be5d43605d266b7b194be8429ac7523089d61ad7587b2b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
