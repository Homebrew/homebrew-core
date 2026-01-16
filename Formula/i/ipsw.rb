class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.648.tar.gz"
  sha256 "e06dcace1b2d9fb791b3dbb19bedfc512db011c4dc76c420004a9d485db9087a"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "924fd16fca4322b1385d277819592bb0232a9115f208fd15c2f87174d0ff94da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb86c9886e9d6d77cc80312296355153aa7b408322dae44678323dd3c9e76e0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "928dc275ca6117a21aee58ce2e3fa1bd7edfda53aea0f0eab63bde0ed0fe20b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c631fa8b104e3f54071c80b281cb13b62a847d0c36740d171b4c7b01c973109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8d6407d502526ef581d358db35fa3e6d7802d357a77e26199392ac3a1b28645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69657dfb2bffaae8ccb7d5fb15f59a2eb7f169c44482a784bcd25f259c7fcdc9"
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
