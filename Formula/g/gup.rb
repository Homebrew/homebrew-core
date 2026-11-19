class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "72d6db19284a9c0f5ccbbcceb24b655e6e1c5feb93fcd82edaa2b31eff0e02da"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e589e58f81d271b67f53ff6a725726c847f86910c2a53575ee1aae58f6dcb15e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c0bf474a3faaa2db59db45fc6c65638233cc2d4ac0bdd9e3f3cd6c7ff45e611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d803b9522038650f21f4a704f832eea5957e4328b809197741b2dafd5598c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "865276503cfd1549bd04737fc56e342bf71d3581dd3a65998183d1084185777e"
    sha256 cellar: :any,                 x86_64_linux:      "fcc7bcff7f4a35b60eb4ec9758400924e39a2fb04d47666e9012391701a6ac6b"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gup", shell_parameter_format: :cobra)

    ENV["MANPATH"] = man1.mkpath
    system bin/"gup", "man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gup version")

    ENV["GOBIN"] = testpath/"bin"
    (testpath/"bin").mkpath

    (testpath/"hello").mkpath
    (testpath/"hello/go.mod").write <<~MOD
      module example.com/hello
      go 1.22
    MOD
    (testpath/"hello/main.go").write <<~GO
      package main
      import "fmt"
      func main() { fmt.Println("hello") }
    GO

    cd testpath/"hello" do
      system "go", "install", "."
    end

    assert_match "hello: example.com/hello", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "hello"
    refute_path_exists testpath/"bin/hello"
  end
end
