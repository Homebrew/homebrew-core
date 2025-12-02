class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.640.tar.gz"
  sha256 "6fad1b9b6857f3e543ed6d8d9d31532f33232069c91b2a4bdfc1d13748c24306"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97ff22a4253faa326ddcdde7bc1d8f04ed8cb9a039650e43987d112d8aacfe05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d135669d3746d47014c647496168ece33f991d7f41bc99f444cc8ad361eff87b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ed89da63d03a24d612f513324155d58ad60690485a6cb6823875adda8a28e2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "26c9ed51b5a42f7cba1f6fc317ecd69f10da7af59a6d43fe509464c98413e21c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dea6f9f683383cbe8d61e9207140926d07f44f8fe09511d8621874628f26a69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a75a32017dcf9cfd76b8b5cafa4d2ddf5c98653c42da35ac130c452b602424"
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
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
