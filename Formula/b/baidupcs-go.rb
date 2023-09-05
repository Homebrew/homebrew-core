class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.9.4.tar.gz"
  sha256 "feb6390ad5247feeaed791e2e4be3ec0c5fdb271c876675da186e5411c69dbfd"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ae693a8138c158a6d912104f9b0f939477ae1a5f674fc3da642043ef981af69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09844c05e9a7b2d120ec9cd37e1a2d880ae6ea790ae44d1f3c1f2ccd4f337cf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1098ddabf2484c021337b9fd46319aca023ff3778c4dd839a9bce0e78479a1c"
    sha256 cellar: :any_skip_relocation, ventura:        "ad68d32b86e041106f8215e5597a2916ac3f600c32ad3c329c22e8ddf8fc4184"
    sha256 cellar: :any_skip_relocation, monterey:       "90474630a67621c992da530c9f8d9c0382272adba65a9e7d29a42440193b079b"
    sha256 cellar: :any_skip_relocation, big_sur:        "52c6aa5f2bdfeed99a6e155e5566ffce5c8dba704734457876284ead782d539d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb9032cec87e577304becf81a9315979ccca5397c211002f54dfcd330db19f6"
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
