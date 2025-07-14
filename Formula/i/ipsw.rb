class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.622.tar.gz"
  sha256 "277eb2b3419aa9274877a781891b0f8475d5569e1226dce14eb8dd8209125b36"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05bbc5d6ef63276007f4b09971e93541f1a6ac944af0f1782f3b795dc2578442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b88387b735f8bb636781504754e08c129aa18be96846dc7938fd158d41645ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2a9e6272a371df013ecdf6d48b0c9a2b3d6af5fdd92f629270518e3ed8de4b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f81aa5eea17eb4eda758ac99881f7506c046921943b7c3655e03a057189e6b6"
    sha256 cellar: :any_skip_relocation, ventura:       "9ae7e617285a75d2b6b2de6723a91db3c784ba1650359d6215170d7a1bd598a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b181f968df6fd6598f25cb6d85b9d981e63f471dbbe5de115f48e69bcc65bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d09ea2a1d34bb9aa34b492b8659ffcf789f89a7248c4b2cb15cbdd36b6eaae1"
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
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output(bin/"ipsw device-list")
  end
end
