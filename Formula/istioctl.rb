class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.9.4",
      revision: "13fb8ac89420d8cc5b3f895adc614233e805a61c"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "0ef426cf30bfbe686b6b31687aa3b5e2f54c68dec1030b9946db0f98c15f7ba1"
    sha256 cellar: :any_skip_relocation, catalina: "0ef426cf30bfbe686b6b31687aa3b5e2f54c68dec1030b9946db0f98c15f7ba1"
    sha256 cellar: :any_skip_relocation, mojave:   "0ef426cf30bfbe686b6b31687aa3b5e2f54c68dec1030b9946db0f98c15f7ba1"
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
    dirpath = nil
    on_macos do
      dirpath = "darwin_amd64"
    end
    on_linux do
      dirpath = "linux_amd64"
    end
    cd "out/#{dirpath}" do
      bin.install "istioctl"
      bash_completion.install "release/istioctl.bash"
      zsh_completion.install "release/_istioctl"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
