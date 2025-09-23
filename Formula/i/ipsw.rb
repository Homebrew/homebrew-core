class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.626.tar.gz"
  sha256 "27eab374516df6055e6bd580fb7aad9b5774ea6aa2fa53e7644d17612f142e5d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e6445cb58e8aaccd43dbf023ab6cf3885dfbb0ffb9c3062b40e35f101014f44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9ca06b208a0d4767b8f3c37d0fe91f5e029e1195d9cd21aebb840245ed4797f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "909124d94f1d21895c35d20d9748fc4fcd69706ce7b65fd194b073588b3e77e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10ed0c204db2be6f42b509ec1b0252ae3124c27b1124c788a1c49563823f7d63"
    sha256 cellar: :any_skip_relocation, sonoma:        "787d954012cd72a663c6256a890eddec7e8ef2f5d948329233d9e33f7e1fccdb"
    sha256 cellar: :any_skip_relocation, ventura:       "3df29c71c35aa9afd5a7a6f8cafa6edc2c778a2878cfcb33b2c4bc6d43a512a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16929c7e49028bc23cfcdff07ee475f6f469ef679212039933e2fe65f9e3b99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e229bbc497c0372067e9e953b100bcff6c3f13998da627ccd96bd9425f1a7913"
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
