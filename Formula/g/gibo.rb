class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.21.tar.gz"
  sha256 "83cb600518aba65c0b3d7a7393df02374da238d2e91c45123fc1ab204e0d80d7"
  license "Unlicense"
  head "https://github.com/simonwhitaker/gibo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "745b710d3b23c34731a129042e1e413b0af93d58a18002bebd14c124a5e423ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "745b710d3b23c34731a129042e1e413b0af93d58a18002bebd14c124a5e423ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "745b710d3b23c34731a129042e1e413b0af93d58a18002bebd14c124a5e423ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "09744abc9c5ab012bea4f2884531b8638d1bdcf5662bc8acdb2b0bcfe20a0749"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5eb7ac542dc3e6e4958d12832af4d2daa7d778fb29b028e31fa6e5c6b338b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f37f7e5c7c05e8b46764cb902450672bedbbaa4b0fac8d6f1d273d23968b2024"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
