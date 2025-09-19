class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.214.0",
      revision: "c191958aae0a20a7c77ab110e591f05cdd463fb0"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dac819a1c8672c94e40708aecd0411437476596ea940ebde323a631569eea579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "888169a6bfe79cf9ed82088dd9ec960afbae05aa26a2fb4bd33b70c049e8e6a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fbd5be817040d912b9b5d2472ca478466b15434f3e2ae9b750c41a46877cf0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84c89258049eb43ad6da67c160fe35d4415e7328c6de139ffef8ed6242893122"
    sha256 cellar: :any_skip_relocation, sonoma:        "e39756717c4ee025d3fa20ff7c1c21fcdc3645afa49be9a8f2438107aa2c8e25"
    sha256 cellar: :any_skip_relocation, ventura:       "b51cbfe366a1a72b8eb1c648fb66e7f390185e9cdaeb273407739510ae06b830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02c14893bf549c5c6558cdda253335bb33a9d22917760cd544bec9a890516082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a011b68522924287804f6836dae75c0ad92e0b663b36be6c7f4abbecd521a0"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
