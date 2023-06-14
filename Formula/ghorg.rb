class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "f58b3df0c34440f5d5da2a0925287134e4ce7c71cb9f3c15a40fafda3bcc78e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68614634a52d4981dc3e31fe53b857cea50d01f1d68e63a41eea31794a3d266e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68614634a52d4981dc3e31fe53b857cea50d01f1d68e63a41eea31794a3d266e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68614634a52d4981dc3e31fe53b857cea50d01f1d68e63a41eea31794a3d266e"
    sha256 cellar: :any_skip_relocation, ventura:        "e529a134b5dc7f0a807328b7e6fde2deea764a73675613e70c72bf0837c9c061"
    sha256 cellar: :any_skip_relocation, monterey:       "e529a134b5dc7f0a807328b7e6fde2deea764a73675613e70c72bf0837c9c061"
    sha256 cellar: :any_skip_relocation, big_sur:        "e529a134b5dc7f0a807328b7e6fde2deea764a73675613e70c72bf0837c9c061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ca1974aed094d41190745628254b4780abb552aacc102d727f819d2ed096dcc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
