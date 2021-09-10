class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.3.tar.gz"
  sha256 "1799a64595cb820f62be8a62f0a2969c589eea4175b7b25d0b8712ec836c5632"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5965e0e90da8f9382fb7454360ba78da1f383807e717f79a11bb8a9d707901e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "c68293ae2a856aed1da5ee21b407fbf7d7e1d50b1561e3db39d41720d6362e3e"
    sha256 cellar: :any_skip_relocation, catalina:      "b4ddc705d96d8e25d257d46cb5ebf08316baece09ea00c6c74b381165271cee6"
    sha256 cellar: :any_skip_relocation, mojave:        "5d18d7f7865b9dcdb2479d2b7ed834c7b1117ffcbb3be042df27895b04295d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f748bfb0574bc693e73647191aa84c3e13d099612e29240b73904d7c3ba66bf6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
