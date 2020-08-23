class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.7.0",
      revision: "2022348138e47498c4b54995b4cb5a1656817c4e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ada28021256a12012af3b6718bd3c31bd6c394aeb37d53116f396fc91a35bfd3" => :catalina
    sha256 "ea17265935f80dfc1dc22b31b562b6cfa75c636eca30125ff1df86cc03c8a11e" => :mojave
    sha256 "e1fd9c5d28f89de11178c33b1ffe71c4bd0533ec244a0e557346f99a607b865d" => :high_sierra
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
