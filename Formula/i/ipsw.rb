class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.581.tar.gz"
  sha256 "6542dfbfc3d3c76b48ff8851c76ed2498895cff83ad56a08e910c33f834db3b1"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6889693cada46ee39dc45ea02176d9c377f5b46f5e5f82286e58ff373f02e365"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20848be1295960023d0a3d3e3eadba69ca6527846d0c103e925905dbb62fab67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5716d48906fd71e58a86f7ed2f342a004e65e63cc114f8c6d539027b1bf53db7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1708963f477dde2d2e414a6838d004e75b2eb22db718ac7459401f3329ee4802"
    sha256 cellar: :any_skip_relocation, ventura:       "38221e4389b04ce6b98206b5fa94b3c1019b5fc9e56fbbc3177d8f1049cb3b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c342863e100df65841ea1d7ec0eb21c7c94e7950b1a592f8ad251c31816c3312"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
