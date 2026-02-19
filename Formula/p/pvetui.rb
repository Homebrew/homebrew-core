class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.18.tar.gz"
  sha256 "f1e4149879309b19b72218b65f194a217f6befd38434e4aeeffe5ea00ff16725"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d84a2ecdb67db5719e5ae44af9fd26a70d5e2e91be02a2e207e0c8e545377c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d84a2ecdb67db5719e5ae44af9fd26a70d5e2e91be02a2e207e0c8e545377c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d84a2ecdb67db5719e5ae44af9fd26a70d5e2e91be02a2e207e0c8e545377c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb468c347dcfb3afa5a5ea47ae989a71b477635cadae25e72783ce73ea1d3f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22204dfbde853c39f9c31e97e0bada942f88b12eb1d938e72c63a785950d9bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b3f193d0ef650968e3ca6d08b4cbe7fde3224f53a0e9ce8560f7cbdeea43181"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
