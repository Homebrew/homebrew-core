class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "d196b7daa0f5ecd49a9dfb735650d7ff8f4ab2df4ce8e3b4d0ec1cd00a457c61"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccd2f3d722fae5a3724b2b21dde7ca0763b080fb9f6832ade261e7f98e2f8340"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d6791f18f2bc8fa5eb8c7602b0e365fd61e33c33e87e123558b203fd41745a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cd3f961c6f8aa4c9aaa6a586f08635930a94052d9ca8b9d0247eef8bbcf1ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db51ef3d2d1b5852c8639d0fa0d075b6162ecd10ead1d2c23ec04a5acde6a3c7"
    sha256 cellar: :any,                 x86_64_linux:      "3f557ad6a9cd57eb779dfd4c490f6614dc3d2f7aa8fd35158510b3f5a574b397"
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
