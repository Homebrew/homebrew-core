class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.6.0.tar.gz"
  sha256 "238ace11966ab3b1f99e5488a9f161ebc97aba7600a8f09884110d0572309491"
  license "MIT"
  head "https://github.com/muesli/duf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee0e42d0616cf301e64fdcf1e4258b5f2dc0a3142447545ae4fe5a7a63e5c8d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b4d9f133d69a9b09f086b12019abe91deb60aa41a8404cd948bccf13397e2f7"
    sha256 cellar: :any_skip_relocation, catalina:      "638e29c4c713d9c284f132e34239998dcdded8cc9cd8dd4766123147cc31649f"
    sha256 cellar: :any_skip_relocation, mojave:        "f6457fceaf237482f7985cb6fd023678a1fcc598d72570a2f550ec82d4fc272a"
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
