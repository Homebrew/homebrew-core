class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.668.tar.gz"
  sha256 "ad3e75e401c4874f31d23789d779d4605d1210de5230743e9462a9d7a573c6a2"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "741b73ab54b81a234722fcd21447bc26304e9a7c1a05631d7565101bad2f90d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f84fccc20a7cef1d6990f105ba2790f369341c74c08bb9e74db2731909d7de92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc332900dd6c18bb1f9ea1d290b75a2c479ede3e201f4f00f2562bbabe4a1fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7ce7bd231637b37cf83e7e1b7631679f8f75c2aaa676a7bd3d02b8384e02b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6c3e1baede98745fe1972c2fcf874feaf8f995aab65d55de29e78d9c86959e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b487934f5519b3d3adf7578f03b9347eedbb2ca665dd0fbb0085a9f8f6da768"
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
