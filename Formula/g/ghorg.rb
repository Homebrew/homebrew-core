class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.17.tar.gz"
  sha256 "edeed22b64898a8d2eacb6c6de85d8aa0a16bc762d546b56c7c06f722d46a040"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6904ed2eac3d916d3816e5ef8153bc49eeea88e0738862a913e2cf2654b81356"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6904ed2eac3d916d3816e5ef8153bc49eeea88e0738862a913e2cf2654b81356"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6904ed2eac3d916d3816e5ef8153bc49eeea88e0738862a913e2cf2654b81356"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "719944dbb2616f4d845824182a7bcf75859eee385d54a750450d465481cf5645"
    sha256 cellar: :any,                 x86_64_linux:      "1f5606e02ce8885e33b0852fb9d94a95fd476522c0343f5c5d0ebc9acab02fd0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"ghorg", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
