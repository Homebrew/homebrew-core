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
    sha256 "4800b4e1f1fb2967dc36aab48dc535e9d7ea9673b94b05a381ac9e522d3a5c86" => :big_sur
    sha256 "810e84cb98f5e1d75715eb8376b44c64cdaad7be026bf8f2461cba9c814f27cf" => :catalina
    sha256 "0b5585969427eca2432fa787cb452f6bddca55398d0e17d279ca58fa909f8be7" => :mojave
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
