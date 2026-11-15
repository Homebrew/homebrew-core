class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.23.tar.gz"
  sha256 "a529ad07de46728eafe3aecf01612128bee23ec8a856ad6484e94a21c98dd9e8"
  license "Unlicense"
  head "https://github.com/simonwhitaker/gibo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0637f449bcff29b242d6fb81905f740e49706936bca9dd525ce16d4a2547fc7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0637f449bcff29b242d6fb81905f740e49706936bca9dd525ce16d4a2547fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0637f449bcff29b242d6fb81905f740e49706936bca9dd525ce16d4a2547fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "932b5dde0328e06cd62112565d321ae7b3fc446a9e3436d1937ab2a9a94c78fc"
    sha256 cellar: :any,                 x86_64_linux:      "a88ebe4e23e494b5e14270a3a23100783aab87d7ba9834559497d928fa42b1a5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/simonwhitaker/gibo/cmd.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
