class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.702.tar.gz"
  sha256 "cc2ab36295b16a96a2d12937257fa6e726ab74cea7ad130b6b8d6ad21bdf7400"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "def05c331a93ed8ce121cd1f3652e83f9743f62590bfc2b4152de2c1454ea637"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d8d41782500827682bce0d2e96ce379752643a0d23d7603ce21211696f914f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fff909cd6fcba5491a03a31f8f20ba0be1782b450ee228217d04e1253b7d6c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "94670bdf997664c584bff1689494194e50b7086afbe419563d83056d62739c50"
    sha256 cellar: :any,                 arm64_linux:   "2f67693198a1e72c94aef7467bec0bb3f4ca3b3d0edd577ed91339d38eeea0bb"
    sha256 cellar: :any,                 x86_64_linux:  "f0091f7cfab145dce412a7b9cc404ae45b21c17d0f21d01b89c954efb2922a0d"
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
