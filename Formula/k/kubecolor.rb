class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "1ba546f29b2c4b1dfd3bf59e4a6c38384b309e7b011b8fe31d670c41d48339ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e41652a5c54a92710f28de5ae107a60186f758cbeb20091c403f98569ec96ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed13397bc5bed2cf2346134aad0c8966dc42c3a4d022430e301b692c885d2241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "983342e1b0aa64c1d525ad876427b58ad40c241cf6fb636cf3bf68c1a0737258"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e829eee09923e353ed99d2ccfb65c743fced839af90eb72386881906b1568b1"
    sha256 cellar: :any_skip_relocation, ventura:        "0db439e75040c6467375fa5b0ceaf5d79a3201901d35ab1c4bc90111ef7c45b6"
    sha256 cellar: :any_skip_relocation, monterey:       "187b1108e9ecc40857c2541407e92126adb0c1941750c2fbb77c592e3d497b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464214d1b3ba8ee2fce2a2d5bc33807a352c65782bf7a139ca687220b2480f31"
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
