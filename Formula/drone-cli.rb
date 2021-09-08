class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
      tag:      "v1.4.0",
      revision: "43e52be34cbf216fece99d8754b5ef96527566be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b6df453dab028af63df937c08d5a84f6ddc71caa4997b79e859e8538133ffb4"
    sha256 cellar: :any_skip_relocation, big_sur:       "0478ef553b34f2f7d202046239921a67262528b4d432c5f467147401c8900bc3"
    sha256 cellar: :any_skip_relocation, catalina:      "b00a555ed82c4319864ee32e93fcbabd4840e8ead331ec49e0c40c781c02f85d"
    sha256 cellar: :any_skip_relocation, mojave:        "2ffef48dce7c0a8dbfd62d11c2beff4753be01b3cdd74bbd2f932f559bf8bc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f0e2918297680fb63b2359304f1dcb203ac67a3792dee9a340613d50975087"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
