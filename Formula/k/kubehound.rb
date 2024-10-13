class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "f00f864873475f5b13413575dcf8a3de92c4de65dfdbd0b7d4bc34ad91f58c4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad229fbd337169f6bcd2fdd46d87f1c36fa6b5a462fed79dc409e8f1508bab81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba7cfa08409ef456cb2d1b051baee6312ff3117c690711614b190fa639678589"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b03288e6617df5beba90ae89372b9726cdb6dae08291667f49116b6a0c1706ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bd9cafe2c74c5fb2276b733b8ee0f4d0515ed8a501401d66eea8e93906ee997"
    sha256 cellar: :any_skip_relocation, ventura:       "e986c40e993a568fa0c7928f749e6db68f374b7ab7d23d524eca078a25a51ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae2d8015827c37d85843a20ea50c25fd728227ec9cd38efe417cf88c21428068"
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
