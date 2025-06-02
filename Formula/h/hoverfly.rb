class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "642a75619a0b405807fb6291ae36649c2fd8b554a22439ade702e49afab885fa"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5cf9d2f0a8a656da0a985dd617636f39fe2a2f0d55ee198ca7cc5009cc7b337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5cf9d2f0a8a656da0a985dd617636f39fe2a2f0d55ee198ca7cc5009cc7b337"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5cf9d2f0a8a656da0a985dd617636f39fe2a2f0d55ee198ca7cc5009cc7b337"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f7c97b9e681aba53f9f1377322b0b777baa54263cc0e65c6939d87c9e0752cd"
    sha256 cellar: :any_skip_relocation, ventura:       "2f7c97b9e681aba53f9f1377322b0b777baa54263cc0e65c6939d87c9e0752cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31607ae6c6d309161732d4dd67a220c1949febfd2f41aa0c1dae82aafbb39203"
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
