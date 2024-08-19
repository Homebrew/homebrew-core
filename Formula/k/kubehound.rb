class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9f047d7fa3f5e27d1b5db974ce34622e6960c7ad9ab7b354572486c6f08362db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a02aba0d6a0dc6e0f5bc9c5b02f6148bb66d42235e2e2d92b417c7bcbfcbc629"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1a38640d095b9ba84550564aa457dca1290ac9575e98190a2726d10b710ba0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ab4b02298d45ea221457c5455fa662227261982a5622a70e7902dfe81f66c58"
    sha256 cellar: :any_skip_relocation, sonoma:         "1be0bbd65c84695b90a1ce21c716b07595f1d291cea7b4192c555712a6c34fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "e1a9ec7f118f611dfb69d2afc642df3e3e385f5d39cc95e513d490e68cfa23ef"
    sha256 cellar: :any_skip_relocation, monterey:       "4e98e2229c5f01c307e316916195c0e8eaa3895792abbd58f3a7476cbd3c1b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4066baa79df387838477c5665820fdddf42042eb5d212cbba6883f59e0836cc"
  end

  depends_on "go" => [:build, :test]

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X github.com/DataDog/KubeHound/pkg/config.BuildVersion=v#{version}
      -X github.com/DataDog/KubeHound/pkg/config.BuildBranch=main
      -X github.com/DataDog/KubeHound/pkg/config.BuildOs=#{goos}
      -X github.com/DataDog/KubeHound/pkg/config.BuildArch=#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubehound/"
  end

  test do
    assert_match "kubehound version: v#{version}", shell_output("#{bin}/kubehound version")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    error_message = "error starting the kubehound stack: Cannot connect to the Docker daemon"
    assert_match error_message, shell_output("#{bin}/kubehound backend up 2>&1", 1)
  end
end
