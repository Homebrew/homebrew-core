class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.628.tar.gz"
  sha256 "157b703005dabd722b0332b0a0b3263ec189488857bd46e7fbc2afb62251cb5c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84f5f6857135214e5fd73f0856b581a75882895bd30cb878242a98c719822561"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ee39b292851dca57b4475b6f677bcf7968efcb31c6f3b5fc0cb2de53c49f834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3ea11bc7f2a3cc708df30be6b51fdba8204494b8205b0f7c2041d085e309ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc5ecb4a1d26f430028dce190c6e4f4ea56458a79e7d31199cfaa787c4b86e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6487a4f887be8102894aea7b80b7ac4f7d2ad484db81251aea6bad4a879f790f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53576ae20c8c2e27f9aef6689c43551c7178cbcae4741dedc7809c31fdcb1450"
  end

  depends_on "go" => :build

  def install
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
