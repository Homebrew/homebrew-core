class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.8.0.tar.gz"
  sha256 "6b483e68ec783821d07f03cb85629832b8c6f302a7d1bca25af142f891381e8b"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c704ba3b5361d571ec3dc2c40cec90d5db83253e51271464d486da9145ff5f2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c704ba3b5361d571ec3dc2c40cec90d5db83253e51271464d486da9145ff5f2d"
    sha256 cellar: :any_skip_relocation, monterey:       "eab2485bf3467c0be77983348430656856faad10d6b8b2947162bd6448c15536"
    sha256 cellar: :any_skip_relocation, big_sur:        "eab2485bf3467c0be77983348430656856faad10d6b8b2947162bd6448c15536"
    sha256 cellar: :any_skip_relocation, catalina:       "eab2485bf3467c0be77983348430656856faad10d6b8b2947162bd6448c15536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c51a0704f4f7c4bf6690e58c7fe841ce4af109def8d242146c938df82352af4f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "json"

    devices = JSON.parse shell_output("#{bin}/duf --json")
    assert root = devices.find { |d| d["mount_point"] == "/" }
    assert_equal "local", root["device_type"]
  end
end
