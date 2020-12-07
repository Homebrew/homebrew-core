class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.5.0.tar.gz"
  sha256 "d8879fbf091cd6f6a3b95102fdeb7d21b7fc8200df1a9864b89d8e87057fc9c6"
  license "MIT"
  head "https://github.com/muesli/duf.git"

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
