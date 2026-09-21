class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.14.tar.gz"
  sha256 "64d34fc7c35cf770cbef4cbab43af18d093dde79e5d5200e185a07c99945b4fa"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45a9ba1c4c72f4b78648878c4eccfadc89b10e92c37c3e9dbfdf11a5929e6ae7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45a9ba1c4c72f4b78648878c4eccfadc89b10e92c37c3e9dbfdf11a5929e6ae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45a9ba1c4c72f4b78648878c4eccfadc89b10e92c37c3e9dbfdf11a5929e6ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5db3521a8beffa0b523b17a7568131cef24d630ee331f10617216f8cff510a8a"
    sha256 cellar: :any,                 x86_64_linux:      "f5444079822c553c1cbe4fa82f64bda80f20153eb9e829a59bbee9afe85f402e"
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
