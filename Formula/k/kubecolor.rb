class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "68df2c57700095d4598f91807913a6d8052bfe2ff20046052fcc7350a1a34423"
  license "MIT"
  head "https://github.com/kubecolor/kubecolor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d69609824745f1ce761450aa5dfa153237d99e179310816b6bc51d9e30242b50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d69609824745f1ce761450aa5dfa153237d99e179310816b6bc51d9e30242b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d69609824745f1ce761450aa5dfa153237d99e179310816b6bc51d9e30242b50"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15be243a5ee680db0fa939a3aa20f34db76834b9c648f10cd0f5320acb2971b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd0dcb961bf16c19f64a6c3276b7c432ca5c9312aba94871356445014a5c6507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79297c1478d18887ebe83fd2078b25403eebbba9cf01550b29954cf5cb9bde4b"
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
