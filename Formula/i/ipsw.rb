class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.718.tar.gz"
  sha256 "5ff4a7387b4547321e8a3b8853120b5c90cdffe7ed58cccde018bec3500e9608"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9dfff1221cbfa4e674f2abc52c6f143fadd977aaf9e117071f715b6ca8540d0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00910793e4f5ab5d5d72a2a9d9b49a3b1dbadbca3ed7fd0f03925d31426ffea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ee6594a5a4d1bac24ac1ed6a3e20057f11b10cb27f6e099ade6c0efb5d4f68e"
    sha256 cellar: :any,                 arm64_linux:       "6eafe21290c87a2725bc5db96b60fd5d16359f524243efa90c564c3abf6d3980"
    sha256 cellar: :any,                 x86_64_linux:      "4f9607d63f8abdb1782c2a116fed5a9a236972a7fdd204751b0411670aaf23d4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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
