class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.10.tar.gz"
  sha256 "4135ccc8fc3ea1f606fcc5bd817e01a169a23e05865f4e4081f2c98c21653908"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "951b6ca6e05d7e4df3f98c69345f151c4682f39349884c84bae59c67a13fe139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951b6ca6e05d7e4df3f98c69345f151c4682f39349884c84bae59c67a13fe139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "951b6ca6e05d7e4df3f98c69345f151c4682f39349884c84bae59c67a13fe139"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc56b28a7b971494692dd3e20600fdc8890dade7ba716ba45c394a0c37d6b354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3b38a5cead9a69489d6f78a5b984bf709b036f511622cfc199e636a3aebe6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e67c563184b6f8b0e3161c30a0aa8e712605e3ba00368bb6549500e78e9780"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
