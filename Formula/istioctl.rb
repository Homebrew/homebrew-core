class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.10.0",
      revision: "d26cba7e341587453ffeb978f5cf6fbc32f346f8"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0fc8e651038356614e134e42ce7d937b55ba7c79049ffd722e8deb74ce73216"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d5246331142294f9705709fe3004154f92067900af7f885276bf798284a259b"
    sha256 cellar: :any_skip_relocation, catalina:      "6d5246331142294f9705709fe3004154f92067900af7f885276bf798284a259b"
    sha256 cellar: :any_skip_relocation, mojave:        "6d5246331142294f9705709fe3004154f92067900af7f885276bf798284a259b"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    dirpath = nil
    on_macos do
      if Hardware::CPU.arm?
        # Fix missing "amd64" for macOS ARM in istio/common/scripts/setup_env.sh
        # Can remove when upstream adds logic to detect `$(uname -m) == "arm64"`
        ENV["TARGET_ARCH"] = "arm64"

        dirpath = "darwin_arm64"
      else
        dirpath = "darwin_amd64"
      end
    end
    on_linux do
      dirpath = "linux_amd64"
    end

    system "make", "istioctl", "istioctl.completion"
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
