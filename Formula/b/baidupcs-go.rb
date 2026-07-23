class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "0c346a32338c8b82ea80615a51080a5c67f30d1ff194f763e0316e89522fdba2"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17b7a1f6ec1691b4f3edd1b62bd21a0ff2c4be5e759a8a1ec5ef50aae921d9a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17b7a1f6ec1691b4f3edd1b62bd21a0ff2c4be5e759a8a1ec5ef50aae921d9a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17b7a1f6ec1691b4f3edd1b62bd21a0ff2c4be5e759a8a1ec5ef50aae921d9a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "532a45185d4675cf84f41b49a7a07406950e267d128d3379bc78bc9e79987f5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bce4b0ca027f509df34b73c594e2276f4ae1d29422e3f7aca9d1e6bd23f19538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcceef30622f68d1c1a133913342e4455aadee9263713b608ae4bc97da9b026b"
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
