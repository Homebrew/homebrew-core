class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
    tag:      "v1.2.2",
    revision: "2064b97d4ead040ae7bf7924e45a0707d10aef73"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2c15b99b882372b7894935e0cadda2c41735620571335ba8d6b4883aca95195" => :catalina
    sha256 "18fb2d2348f7dc3201734813117c795cae4d93310796fec9c595072647d1c567" => :mojave
    sha256 "9f9e614e62431cd2bb2ab7eb44edfde14c46298d0061b520ac33d7ed1360c288" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match /manage logs/, shell_output("#{bin}/drone log 2>&1")
  end
end
