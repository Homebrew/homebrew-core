class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.9.1",
      revision: "2dd7b6207f02cec8b42f4263ac197434f4ec9b4a"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "44775765884a6a3513fb9b51fde9e3184af36e06d96f229b64de65a9959ca06b"
    sha256 cellar: :any_skip_relocation, catalina: "cad34878e6c3a45c2f20d430b4a02f6a3353a28df2ea8774550bacb67564bcb1"
    sha256 cellar: :any_skip_relocation, mojave:   "a7fc6fd81f16649b4b9e45ad0949b417af53598198270539828cacf176d33552"
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
