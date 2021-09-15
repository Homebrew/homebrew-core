class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.11.2",
      revision: "96710172e1e47cee227e7e8dd591a318fdfe0326"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5126a75578ed19cedc6e67ec10febd083cf4e8667a91e60a64c4edde35b7a6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "822f03e4a1143b90dd99c42298f70678c255b31e0c35a301c101952e669e7972"
    sha256 cellar: :any_skip_relocation, catalina:      "822f03e4a1143b90dd99c42298f70678c255b31e0c35a301c101952e669e7972"
    sha256 cellar: :any_skip_relocation, mojave:        "822f03e4a1143b90dd99c42298f70678c255b31e0c35a301c101952e669e7972"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    # make parallelization should be fixed in version > 1.11.2
    ENV.deparallelize
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    dirpath = if OS.linux?
      "linux_amd64"
    elsif Hardware::CPU.arm?
      # Fix missing "amd64" for macOS ARM in istio/common/scripts/setup_env.sh
      # Can remove when upstream adds logic to detect `$(uname -m) == "arm64"`
      ENV["TARGET_ARCH"] = "arm64"

      "darwin_arm64"
    else
      "darwin_amd64"
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
