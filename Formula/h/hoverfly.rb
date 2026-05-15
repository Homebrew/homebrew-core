class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.7.tar.gz"
  sha256 "e8dd911250c91a1c382a630b0310b4cc097b2f9fcb6026faaefcd6c3d4c69b14"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd5bc3e3c57f74d975f7548f4fc24b41e50be7da780d1f082c0dab4c7797b708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd5bc3e3c57f74d975f7548f4fc24b41e50be7da780d1f082c0dab4c7797b708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd5bc3e3c57f74d975f7548f4fc24b41e50be7da780d1f082c0dab4c7797b708"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f339637ba22d182fc4401889ba276f3d66919a9b01f2445cf35e48a598645e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9223cca1f187847b8da3785d33f82a57df78867a0e60b783f91911fa5bd2ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98432f2f7f1d1431c469124639018d303d0b9f91984968fb096842a2e213c458"
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
