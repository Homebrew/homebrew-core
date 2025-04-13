class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.593.tar.gz"
  sha256 "cb0ddab94f6e89938bea6172114afc5f2f9d3a2bea246764594b722ad0c25fd5"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef437cb1e24e8fdd79485eeb2c875da2794cd78d69db2f348dba999c5c6644a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02b2a2c7f7b996d4691c98514c8442e87a790449cf39db546e6343dfe8951467"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67147db7636ec1e46313359d9f50bc122cc0f715b253a7ea3f7c8bacf50cbdc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc92b51a670199fcd307caa39dd8aa665decce4789cda2f8cb25bce13365973e"
    sha256 cellar: :any_skip_relocation, ventura:       "44c8e79485555bb643f984ae77b54de0c480b006707da8b403fc56b764d976bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54fe26177fc9e3e7afbc9eb31c5057e52efa8cc583a93ca852099519cd347d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec34c9afcec2c1eac527ab15cfa74bc64bcb912b6c52fb88aaf8aa91dde531df"
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

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
