class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.8.1",
      revision: "806fb24bc121bf93ea06f6a38b7ccb3d78d1f326"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "13412f071699e9cd6cd6c326283762b310788826751834f94c6a739a98ca39bf" => :big_sur
    sha256 "4054c9d31253d0de7150b9c28fd29151d18345a6bb94f07843c138521c9f1a3e" => :catalina
    sha256 "c097dc572691619571e769d6a98f005a6b89c37d2aeb247d0af4c1db5dc0ae99" => :mojave
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
