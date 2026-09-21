class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.4.19.tar.gz"
  sha256 "39537b3d2e221c5cec3826c845711903223fb878e93f81a1b452d814c806c819"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ac911d10a0bb60a57032a3e503b04e44584974c53bcea8cd67f1157ae17edae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c51a1093323ea7c655bddacca6dfd31b167e6bf7e468b4d62ac3f15b29f15e7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69281ca8121ff998e7ed8d340b28b082aa9d5ceaa63aacee1346ac244cac94a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53bb3b48c2fcb399726dcd7537b93e0bd1cc877a42fe74a13919f10a4c928dce"
    sha256 cellar: :any,                 x86_64_linux:      "5edc54c85d70f024998be2f78c9f5549cef2eb19a81a3dccd23cd663021a9a08"
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
