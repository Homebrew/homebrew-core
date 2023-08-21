class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "e9a9c11dca9692f0ed7218da2235b632c9fe7cb56e9197e959a7b24ecb1c83c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1beaf9c34a03d2f6f2b03a750a43702e084da99b4fb39d1d7187f5194519fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1beaf9c34a03d2f6f2b03a750a43702e084da99b4fb39d1d7187f5194519fe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1beaf9c34a03d2f6f2b03a750a43702e084da99b4fb39d1d7187f5194519fe1"
    sha256 cellar: :any_skip_relocation, ventura:        "733ff29665963e67bdd9bd91a05501391b4fdec153219e28d9623d9a3941a368"
    sha256 cellar: :any_skip_relocation, monterey:       "733ff29665963e67bdd9bd91a05501391b4fdec153219e28d9623d9a3941a368"
    sha256 cellar: :any_skip_relocation, big_sur:        "733ff29665963e67bdd9bd91a05501391b4fdec153219e28d9623d9a3941a368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "371ae6b719ec2a97d12d34afcafdabd8a52ad769359c37ec999e1cd300458383"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
