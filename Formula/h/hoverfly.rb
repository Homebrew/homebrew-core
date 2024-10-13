class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "7d88ad51fd268bed01078b5fa154a2003df7ad130d6438f3b3c299d73695568d"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c4a58e524e76b21ffbf6f7cec7c511d369683066080dca97e05428038a172025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c3af4256bb0bebe0674fe50df4c445352bb0cd4cdcf35a4946c675cbdf69173"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c3af4256bb0bebe0674fe50df4c445352bb0cd4cdcf35a4946c675cbdf69173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c3af4256bb0bebe0674fe50df4c445352bb0cd4cdcf35a4946c675cbdf69173"
    sha256 cellar: :any_skip_relocation, sonoma:         "351cd9832c0a22d47f746bf1628eef8460f615b054d6c19f5367e4ea7fcc4b9c"
    sha256 cellar: :any_skip_relocation, ventura:        "351cd9832c0a22d47f746bf1628eef8460f615b054d6c19f5367e4ea7fcc4b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "351cd9832c0a22d47f746bf1628eef8460f615b054d6c19f5367e4ea7fcc4b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "387092bd2d2d8aa68f8c8b556d1cbec0bf3d7265c1625c9bf8f8c77bf42d378c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
