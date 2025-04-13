class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.4.13.tar.gz"
  sha256 "b92f1708b1420e85c6b97e41f8a09b127a42c387918cba950543e1713195384d"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45954b389fe71222e902d09271fe5c63ed72eeda290e26a000c830465e9650f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bef911600ab27a0d9c98a62412b782428956cec8e1c32f631a3584e827f2dd0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1d12037661ed2e29b7998acffcc8c066a59d18484aa2940cf91e14716c20cf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "54c98bfa56553cb85c4afba062b9f947d8667bd1fb62a3af96289a7c017ddd84"
    sha256 cellar: :any_skip_relocation, ventura:       "422f21ec5d06681330648c798867db1d630ba57d488850ec3c0a1ef839e733e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8671f9912142c044cf26bd06920dac2cf01c1949090b4e09573e7b3fb424a299"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", "completion")
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init"
    assert_path_exists testpath/"leetgo.yaml"
  end
end
