class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.5.0.tar.gz"
  sha256 "d8879fbf091cd6f6a3b95102fdeb7d21b7fc8200df1a9864b89d8e87057fc9c6"
  license "MIT"
  head "https://github.com/muesli/duf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6f7af02fd6422feeb24fdd9babb145c3f98323e064c5f46dd494d1edf706e38" => :big_sur
    sha256 "ac445821820ebafe2ab4bfaab44773760b8a592c00a167700c32716869bba18c" => :arm64_big_sur
    sha256 "6b0501d446ed33d86614bf447b4a653aec11bc002dfb1fc5f50e9efb6b83b831" => :catalina
    sha256 "3e7b9439d31b8f2486b7812dd741b62c6ff3eed2c691b4c0e87d9a2276fa1b49" => :mojave
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
