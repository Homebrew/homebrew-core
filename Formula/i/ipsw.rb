class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.747.tar.gz"
  sha256 "fa018b8fc1ec3f9f153bc484ac0ae676961df87be10f2eb6ac32dce757868b40"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8aa28a855ce4906f3ddb53b3a1b5db20105f6678b69f8498357b1c70a77a08b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a122398ee0ebe51e879aca50cedc2785d0fa60662fde2b41ffd8fb3ddc01899d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a888b4be2d0dc3464d86a9137ea43f8302d9ed735c696f01c418969400be74f7"
    sha256 cellar: :any,                 arm64_linux:       "dc7cf0fbe9df4325d6e6546f1ad1aedaade0121243e1ab5a4f4e663a22f130c6"
    sha256 cellar: :any,                 x86_64_linux:      "c505ca67cdbdc9082557d4d0047e4141f6d9c5c3c59f5b9c2e41251cb3d73258"
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
