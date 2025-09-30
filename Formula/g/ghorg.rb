class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "fc9374b28ed2d7f6a06e80ef47c6a4c593b66d9fdaa438fc12c6b8678635c3c0"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8983f37e9c14761bac0a080d634dd2c7ed78b345d71ae84ca20cbe63733b03f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5159ba8cc4b9117d791d651a96c832f6e384b0e6caa69e38703d3f9e71434562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5159ba8cc4b9117d791d651a96c832f6e384b0e6caa69e38703d3f9e71434562"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5159ba8cc4b9117d791d651a96c832f6e384b0e6caa69e38703d3f9e71434562"
    sha256 cellar: :any_skip_relocation, sonoma:        "f95e87d82a2fd8e5133c22bc0fa4e52bfa1956ac40cab0cfd2cc4642716fbd76"
    sha256 cellar: :any_skip_relocation, ventura:       "f95e87d82a2fd8e5133c22bc0fa4e52bfa1956ac40cab0cfd2cc4642716fbd76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6b309d1e2ecf207e16a5ac1fd8cc57ecc4cff23caff628425bb23c75dd4026d"
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
