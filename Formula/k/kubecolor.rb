class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "251b3e2e84bd3574a9c628961066c8b41c403de6ecfb83b7aebd0dd5d7018290"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5678518ea6e881bc07ccf1e2e1b5d51b40b8e058f092c3bd46adaa95e41e524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5678518ea6e881bc07ccf1e2e1b5d51b40b8e058f092c3bd46adaa95e41e524"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5678518ea6e881bc07ccf1e2e1b5d51b40b8e058f092c3bd46adaa95e41e524"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cae57cd23b3d6e1d0bde361f2eb93608ca1f4638f186e24f870c765711d395b"
    sha256 cellar: :any_skip_relocation, ventura:       "1cae57cd23b3d6e1d0bde361f2eb93608ca1f4638f186e24f870c765711d395b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b10a83835f58b0cce6eeedcccc14d83b5ab1afbbc1e127023385df694a35a0a3"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ldflags = "-s -w -X main.Version=v#{version}"

    system "go", "build", *std_go_args(output: bin/"kubecolor", ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubecolor --kubecolor-version 2>&1")
    # kubecolor should consume the '--plain' flag
    assert_match "get pods -o yaml", shell_output("KUBECTL_COMMAND=echo #{bin}/kubecolor get pods --plain -o yaml")
  end
end
