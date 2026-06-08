class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.11.tar.gz"
  sha256 "a7970baf8b80b1968a81607f21adc6b19c6febf322889fc3a10f59cb3dfd2cb6"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8ede1256526f9b7bbdf4b914de96ea944c75174608333df52270b0cda0618c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8ede1256526f9b7bbdf4b914de96ea944c75174608333df52270b0cda0618c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ede1256526f9b7bbdf4b914de96ea944c75174608333df52270b0cda0618c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "92ad2c66d7530401e8dc28b469963c9d64a86a4b118bc0e8a47aec1a7588bc77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767fa919a31a01628ada3adc4cb84937f43173b823939ac1c9aab899ddac6ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e44f9db27e124ebd6545f44b9dc285c5029896981b0669a7e7bdfe14263818"
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
