class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c75c4af4998aa10c5cafec65ba590dc805a3e5e551e2a6fa84a4f8dab588551f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d89d841835720f777bf2c115b7dcd0ec1c838651c2212e7f7ee6dcdde2faecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d89d841835720f777bf2c115b7dcd0ec1c838651c2212e7f7ee6dcdde2faecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d89d841835720f777bf2c115b7dcd0ec1c838651c2212e7f7ee6dcdde2faecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b3d807e3f59ee1d641d63bd344b57f352b8f9c2966989d18886de808f8b2013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffcbcac18364b5095b32ec35b534104393e040aba4b96358cf584c02f2cdbe4a"
    sha256 cellar: :any,                 x86_64_linux:  "e74695115508d044e31e9da5fc5c1bc514deef84a6060e50e8e5e28d75d3c5d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end
