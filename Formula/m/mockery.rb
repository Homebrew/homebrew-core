class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "5c8ca1a58c0b31b2827df73320cf9ef8ff09da7e964741602c05ad6e428cc249"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad8d48b40e7d3d123dfd7bb0a9560b1446c4609f07938a4a0f9ff5d31af535e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce074af2c0be00adbb3ff0c20dd3780afae69efb6b078ccd70e4f5fdcb05617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "706ca3cbb36303fd05a057a0586fbbfa6ae058ba96895a89190c4d77ac3696e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "afad75789f443745a2acf08e1cb4669e6083285b4569e595225593a4b46c3664"
    sha256 cellar: :any_skip_relocation, ventura:        "3b2639948776a566375718cea5d931214460612215b8597d1da093e0f5e1a450"
    sha256 cellar: :any_skip_relocation, monterey:       "f77b8c30177267b148575fb1d403af428ffa3a2a1249cbcdbb42669225a3bd54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be28250771005b7b0622a97c0cd4507cd733fdf839f9edfc293d29ca6504ae7a"
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
