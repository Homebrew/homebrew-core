class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.10.10.tar.gz"
  sha256 "e01a440ad3bf329c35dfc99776cd95201869a5e62e8107fab25b1fe3835e2ca7"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577fc9d895cd176f375363191c10505341faa50f2a07b5021ced288dd16bc27c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "577fc9d895cd176f375363191c10505341faa50f2a07b5021ced288dd16bc27c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "577fc9d895cd176f375363191c10505341faa50f2a07b5021ced288dd16bc27c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9a5e1a0f14c2d50e12b2b166f9a1e27525a6ee8d44023dd530c1d2125ff6a69"
    sha256 cellar: :any_skip_relocation, ventura:       "e9a5e1a0f14c2d50e12b2b166f9a1e27525a6ee8d44023dd530c1d2125ff6a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49013c272a86d6d4c990e42fdf7d9dde998115a81b1bffb7e72f436612e14ccc"
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
