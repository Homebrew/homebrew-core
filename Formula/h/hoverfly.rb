class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "f068ac87fb721a792d433771c4598f059fdfc41c3700e66ce217b5dee0253a6a"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e206b129c600803b2e05ed7e82ac29d953e334abb76142067518693e45270c1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e206b129c600803b2e05ed7e82ac29d953e334abb76142067518693e45270c1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e206b129c600803b2e05ed7e82ac29d953e334abb76142067518693e45270c1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cb5fdffb3afbd038060629c0b8cf93070143fa062ef9c3e5974f1a1db79a683"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40f3cce01cfb8bf9b11919ca09a5e7e866cee4588961b8db061035e5a876c5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc295ed9324b470ff47f0c031ad7eb15b3fced2c7e4c5ac325f0b41c05055c9f"
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
