class Cozyhr < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozyhr"
  url "https://github.com/cozystack/cozyhr/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "2b93668c7c24ebdc0588ca15e7821de77879b883c263f2d295fba41fb9b1c05c"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozyhr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f180b5440e264f7eebc9f4ad530179750a23969d1969d8439df058e3a17286ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d7ea9cc303fce894d6159c1f92e2ab49117d4751af5b941d6c01365b18a3458"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "208756b08057215292c1fc34f19bd60d88f21cb4afb1d775c274d4e627bb811c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ad84c9933d79b0969ad05012156142d7b5ec3f98827e6ae2942e12c928e832"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "066f2212f1d69e9ac77f4bda588416fce80863944b7f238499569135fa464f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e2e74e04771023eaacbedb25dca9413598f5e951f8f4320a68fafb3bfc46f17"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"cozyhr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozyhr --version")
    assert_match "try setting KUBERNETES_MASTER environment variable", shell_output("#{bin}/cozyhr list 2>&1", 1)
  end
end
