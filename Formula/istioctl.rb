class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.6.7",
      revision: "2511ab8c8c59a203e77bb804846593c3690fcf4a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "34b2311deaff6b86a17bb7186cc5fac408afc55a3a385669b13d09367d231fe2" => :catalina
    sha256 "34b2311deaff6b86a17bb7186cc5fac408afc55a3a385669b13d09367d231fe2" => :mojave
    sha256 "34b2311deaff6b86a17bb7186cc5fac408afc55a3a385669b13d09367d231fe2" => :high_sierra
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
