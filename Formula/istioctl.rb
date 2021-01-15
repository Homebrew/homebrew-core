class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.8.2",
      revision: "bfa8bcbc116a8736c301a5dfedc4ed2673e2bfa3"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4a6d8c7ad5a03221dace54af14e763254c055e1d91961893d275fd45ae1f725" => :big_sur
    sha256 "f47a6971199e9d4801bf15f6949529a2b27538c63250e626381843af157e8e83" => :catalina
    sha256 "183792238113f53f08c08f42c7fb5857941ee93ce884ee5bfbb6bf6166cb1491" => :mojave
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    system "make", "gen-charts", "istioctl", "istioctl.completion"
    cd "out/darwin_amd64" do
      bin.install "istioctl"
      bash_completion.install "release/istioctl.bash"
      zsh_completion.install "release/_istioctl"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
