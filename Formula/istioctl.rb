class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.7.0",
      revision: "2022348138e47498c4b54995b4cb5a1656817c4e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "36bf8c191c6131bc77e514ce17ad0bffd21c115461bf55d402cd36edcbfd6dfe" => :catalina
    sha256 "36bf8c191c6131bc77e514ce17ad0bffd21c115461bf55d402cd36edcbfd6dfe" => :mojave
    sha256 "36bf8c191c6131bc77e514ce17ad0bffd21c115461bf55d402cd36edcbfd6dfe" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
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
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
