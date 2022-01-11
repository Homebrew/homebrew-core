class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.7.0.tar.gz"
  sha256 "6f70fd0f0d51bfcfe20b8acc8c3a52573fc1ceed44ce97dbbb9d470bbe4467dc"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f26aad46efec8b7eb2f7f4bb171df069a59cb97c2c8f5544a6387ab1455a30c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f26aad46efec8b7eb2f7f4bb171df069a59cb97c2c8f5544a6387ab1455a30c"
    sha256 cellar: :any_skip_relocation, monterey:       "91f5b21829679cd1ee9ae3455feed392bef5519d53afbc562271f625bad059d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "91f5b21829679cd1ee9ae3455feed392bef5519d53afbc562271f625bad059d0"
    sha256 cellar: :any_skip_relocation, catalina:       "91f5b21829679cd1ee9ae3455feed392bef5519d53afbc562271f625bad059d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0083b8706d77389a3fc916001ec864bdffb972c9fe4d71c4320a2e8088227f79"
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
