class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.5.tar.gz"
  sha256 "e7e42c0d3d09f33e4af2e2406c00143eb5d97ed13d1abb8b270403ac1e3e4b66"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e14d341e4a4752cd02a5128ef421b1d73280d811361f47eb9cc580e9192badd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e14d341e4a4752cd02a5128ef421b1d73280d811361f47eb9cc580e9192badd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e14d341e4a4752cd02a5128ef421b1d73280d811361f47eb9cc580e9192badd"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c1a8afa5acea382e654c71af66a1d28cb67433a6a97eee7e00862afa639688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17cba652e18345f329e22df77cb144f6ec6a2b2aabb777e6822cf61335f9468f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e8d2565aac183ff682e031545f6072b7a03649394856d5c7f78ac4b28f15b31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
