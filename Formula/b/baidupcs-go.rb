class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/refs/tags/v3.9.5.tar.gz"
  sha256 "5c4990a488a742c52b5429546bccccd9f195c7889cdef5d86ac1b28c95fc7e6c"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b1cd34b45af125bd0d93bd506f355f3ed112bf84b2d17cc19d3be76ae074723f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c229a61457af705d9ac3058e72db12f12c8b2465e907b2466d88a5867bdace70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbbc175c0c0dc615c264d8f5ba4cc24798d13c69da377593a16d964556ad8dc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e0af826ec7d7f69df4839116748cab078aff181c4e11bc783cafe8950ce1f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "79ec951150f69c40d416520f4032b3fa2629cdd758cc292c49235b3beaea1313"
    sha256 cellar: :any_skip_relocation, ventura:        "f1e0b6984a3691e38abcf1460517d5cb1d9840e54a800888d2403741395bd6f1"
    sha256 cellar: :any_skip_relocation, monterey:       "08b6a57c59ab8f07c3b3665b3d2dba93d781c7e24ba3e3d36cdf879c37d3887d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c2c291fef9739671cc34200270e1f2f1d105332a6850f1d8e76af3e72834f31"
  end

  # use "go" again when https://github.com/qjfoidnh/BaiduPCS-Go/issues/336 is resolved and released
  depends_on "go@1.22" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
