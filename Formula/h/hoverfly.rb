class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.17.tar.gz"
  sha256 "2f912ee7cb5b071a28eb7642b2bd70111f255355782b8750906cbd569984221d"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "590d5d50968a53693974f6b00d8d09451eb33832808f8b41dda008d312075e7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "590d5d50968a53693974f6b00d8d09451eb33832808f8b41dda008d312075e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "590d5d50968a53693974f6b00d8d09451eb33832808f8b41dda008d312075e7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8015b27c951a095936c497bf39c5b208603bcec010503b224056808cc3370d2e"
    sha256 cellar: :any,                 x86_64_linux:      "58c3b4e4d0a1c7d3dec0b601d5901ec8d8cacba1c63ff22a14a8dd97ecd09274"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
