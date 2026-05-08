class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.677.tar.gz"
  sha256 "e4f2bf77d9df214a137abdee1306a9293200875c7d852343d0e471f0dc2fe6b9"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d831d6d9ebb2189b683928962cd294ad9502d14f717528e88a93846a4e76b7cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a41d16d46391e3e2606535a8e87ea85d2d13b8bd14c519c255f049ed8f0d55f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c1c6a020ae720d697bca3ebc0154093af63235d886a35cd00e703ff3c82ce8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "30ee1260a629fa54ef7551f69016e397af9f8d27e548c12ff2adce07d83638e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b954eab86c219870c9cf08fb6dd53039005d1470a508e9fcb085a2776daa4329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecdd5b679140b7aeec910277d937ebc0f3a9c73ce36feecd5e49900934d2691d"
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
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
