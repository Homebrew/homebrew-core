class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "5e132503246418bb557e6d0769301a6b2308a2b9de7678208919c26be4bc9d62"
  license "MIT"
  head "https://github.com/kubecolor/kubecolor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48a0def1991408723509c3a5ff6f70c4618de403c432ad9b10a85908def0a0cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48a0def1991408723509c3a5ff6f70c4618de403c432ad9b10a85908def0a0cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a0def1991408723509c3a5ff6f70c4618de403c432ad9b10a85908def0a0cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9cdac358f1c608adea28e0929cf6e5e1269185833876863786e5026b6c01583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "214d391fe0a7afb53e2d8cfe2761fefd7f3806f9d6be91863b4481e0810ba86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d09da01a7ecad4113f7c82387e91b2a75949d6444c37b7664df228acd71db3d4"
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
