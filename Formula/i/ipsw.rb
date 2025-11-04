class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.634.tar.gz"
  sha256 "e18610f865eac8a51915caa9c36fcd63b5b5fb07e33d1675dcf02253e0e42d9b"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca67b57cfb9d048c63c84e4e8d2db930861056c3b7ceebd34478697a656d69c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad55d3d38df5a92a1839e2cc8e93213a078a0688d6cb92f0ca0e637e8c8c6774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9253c6192a7a4a0c2139d5510d4120e44f14589a9fa5cdd70ab5c1af1753f9af"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e49d578b66c7221824c8659a07eb6370265d8e4faa7e13fa14f3d5fafb58268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b14ac691089210cddf4163682449a8b722c05856816382b69230c1c10b5d5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7183d2dadce76371ca1ff763ec92ac74989e4d30c6eda509387340886dd498fe"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
