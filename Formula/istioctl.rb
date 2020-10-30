class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.7.4",
      revision: "4ce531ff1823a3abb9f42fa9d35523b0436e2d04"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1dd8171a45499feace7f9e3de46fbd9bb85f8394832c136df40034e7083e5e0" => :catalina
    sha256 "25abe707b520ccba827731425ca5f85cb8c932ae0a6555782d112099ce98ec61" => :mojave
    sha256 "0f8724a7f358411498c9e075a3e8b0ac788f3773aa0b7ec95f2bd7a80b228e98" => :high_sierra
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
