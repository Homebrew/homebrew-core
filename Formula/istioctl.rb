class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.9.0",
      revision: "b63e1966c245924b10a0915a671a656540ed7a45"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "65b8b87701d36f9eeb8da47703566fac732b81d896766debf358233d18d48a7e"
    sha256 cellar: :any_skip_relocation, catalina: "79b8fada3fc4b608465d28b0b1a8ffbbf75f46d098f5678dce218b9744828c31"
    sha256 cellar: :any_skip_relocation, mojave:   "022808fa50ec115308527a2ad8ba6e7e2a61f78f530696247a8b03f58e1a2f3c"
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
