class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.7.3",
      revision: "9686754643d0939c1f4dd0ee20443c51183f3589"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21fd3f8d152c900924f9442ba4c24496b8fe6efcd1be61c8f8002efdf90441f9" => :catalina
    sha256 "7352427b7578b3e7cac3c5726530bd0cf8be78f9034b3e2182aa46153fe3183f" => :mojave
    sha256 "fbf3642fe4aeef5e9e771e74d7fc893ee39b9c327232139b1f8fd5ea4b817e09" => :high_sierra
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
