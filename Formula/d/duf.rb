class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "1334d8c1a7957d0aceebe651e3af9e1c1e0c6f298f1feb39643dd0bd8ad1e955"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d84f7a6e5b52412a9daa6ec83c42a63f648f688032bef46944006fb430459216"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84f7a6e5b52412a9daa6ec83c42a63f648f688032bef46944006fb430459216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d84f7a6e5b52412a9daa6ec83c42a63f648f688032bef46944006fb430459216"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d84f7a6e5b52412a9daa6ec83c42a63f648f688032bef46944006fb430459216"
    sha256 cellar: :any_skip_relocation, sonoma:        "92a705a34e2553e02be84c25e9bf3b3fb9ad78b18347e865ff42969e6df7ad58"
    sha256 cellar: :any_skip_relocation, ventura:       "92a705a34e2553e02be84c25e9bf3b3fb9ad78b18347e865ff42969e6df7ad58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227b9aac9896faac935cdc96b7d7b92faf882b1ced3657f31d9fe2d32af10fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "714eb9bcedcf3abb357b93cd8c85ad9d70adda67064254de44e40fdf12128ae2"
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
