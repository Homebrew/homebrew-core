class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "99b2126c4d33664220ee8270def853d668ebdb1418b1eeaf93b1ab7d8799561c"
  license "MIT"
  head "https://github.com/kubecolor/kubecolor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36e71da500cbc59671b5b611bf461ca10b103e131a76a3e2ca7dec6363c3a60b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36e71da500cbc59671b5b611bf461ca10b103e131a76a3e2ca7dec6363c3a60b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36e71da500cbc59671b5b611bf461ca10b103e131a76a3e2ca7dec6363c3a60b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bafa41807766b97484a2b52ce12a12a8073c3d0f8f42c9b1c22b2c096c463be0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "377a61b6e424a4ba02829e8269b96de7a09e2f62e1613d087f278f0c259fa250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51bedafaf03131d6e77b1f934e7bfd0a1511060b480f1166ce937fab36b1db76"
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
