class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/refs/tags/v3.9.9.tar.gz"
  sha256 "1eee98de38092950f47e0ed0b2630dbb17126bad71982443f88e73d57290d449"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e174a2462e873b49dfc9b3bbace1155c86d77c0583298c89d9bf5a165badf452"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b77e253a7b66b408d3396cc5d26ed330454fd9c268e1d2b6ec5968591b783b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b77e253a7b66b408d3396cc5d26ed330454fd9c268e1d2b6ec5968591b783b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b77e253a7b66b408d3396cc5d26ed330454fd9c268e1d2b6ec5968591b783b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a821e1a1d004af782a21f180967292c2bf4594e5c5e87e4cd0a1a41c11b4e392"
    sha256 cellar: :any_skip_relocation, ventura:       "a821e1a1d004af782a21f180967292c2bf4594e5c5e87e4cd0a1a41c11b4e392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e4c45c5d893c5dc7348cedf2223ff2935ba1a84e3cce996cf4aa584af5c1290"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_path_exists testpath/"test.txt"
  end
end
