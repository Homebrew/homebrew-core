class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.11.tar.gz"
  sha256 "10b834c74c0e0d0b7ab00308ca7fd418bc996dfd13a44e6a88cb34035d2c84f6"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c41a21732e2e82ca4cb0c886e9b7841e91773686368893ef59196275047faf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c41a21732e2e82ca4cb0c886e9b7841e91773686368893ef59196275047faf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c41a21732e2e82ca4cb0c886e9b7841e91773686368893ef59196275047faf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f438a8a5439700bc221a0cb1a00bf246a4bf515903b8e07c48757e72dbc1bc48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d84895dd707467a9c22c7a573f31c455283d0083b1d87a7cb59993433fa758"
    sha256 cellar: :any,                 x86_64_linux:  "9b6f0d3f2b5343a778590b8d25d2deb017bcf8e5cddc5557b2b3cb36f58cce81"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
