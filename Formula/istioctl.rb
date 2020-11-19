class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.8.0",
      revision: "c87a4c874df27e37a3e6c25fa3d1ef6279685d23"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d47871fc967f98fa67a3b05187438c0695376102cdfc0ff6fca22fd9215d6574" => :big_sur
    sha256 "ad04447c6efaa1d6737cca6e30786284a4a67e5c23d3f1651fe72d6d0e073687" => :catalina
    sha256 "24788010e30202c5da8c2172f8e56a193c6c75912b76f280d4037ad07d52a412" => :mojave
    sha256 "9e8356bca3cd45c820422efd52ed7961dab34d64a8ab10a56f4bf5ca38e1ff5e" => :high_sierra
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
    assert_match version.major_minor.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
