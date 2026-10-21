class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "0bcd0b22ec53e527f06d9a12aa8540f0dfa97ba5ff0c5aa0a095002ff7c90c42"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c29e5af6f6c0a5141973e2ebb47c16b81f89c81dc79fc5b4d5c21cc71de3c759"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f2f1d64e6ea8cb561d3dbc45f7d5967c31e3a0e749512bf36d8e7827fd28044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1e9022f107c4b5f4afc726d3bc42790ca6209373994b159aae20f8a9a9ed5d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50d738ae70d3a3f98ab4dd3f15ef4e79e24afbf1a8b00f6e1556cdd9c68bd240"
    sha256 cellar: :any,                 x86_64_linux:      "6f879bfc111fba845fd6644a267c0608c962d20ed92749708d456394ead09b04"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", shell_parameter_format: :cobra)
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init", "--site", "us"
    assert_path_exists testpath/"leetgo.yaml"
  end
end
