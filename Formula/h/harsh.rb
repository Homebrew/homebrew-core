class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "d5e12c13a049d6783354ba852d1190627cf8d5ad8067c646669de2a3f436e34e"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3542f5e35b58bf8d97a93234be085b36fe6409d7fd54c99350dd2ad63bfb413e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3542f5e35b58bf8d97a93234be085b36fe6409d7fd54c99350dd2ad63bfb413e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3542f5e35b58bf8d97a93234be085b36fe6409d7fd54c99350dd2ad63bfb413e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7487ea2137ffea2d10694b2e2ae9068edd63de8f9e984272f3bcb87f0c6049d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f5141a8ff967102b0357a7a6075ea123af6382fd9d6dd0263fdb86dd07446d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad4e78b485a0b7f93767dd9cc8002e22e90dcdc875d32045192d90f0cde37840"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
    generate_completions_from_executable(bin/"harsh", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
