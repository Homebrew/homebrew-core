class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.9.1.tar.gz"
  sha256 "c15187c8959219fd76dc9330a846752697254544d9978746a8f4c249419f94e7"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4db0453ef19682517b3a3fc7f77da00cab511cdc073c0778ca5dad0fbc58ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4db0453ef19682517b3a3fc7f77da00cab511cdc073c0778ca5dad0fbc58ea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4db0453ef19682517b3a3fc7f77da00cab511cdc073c0778ca5dad0fbc58ea8"
    sha256 cellar: :any_skip_relocation, ventura:        "b30b75a47195c132b679cb8389a27bfc6c308b6d88c583c4329645eba11d68f5"
    sha256 cellar: :any_skip_relocation, monterey:       "b30b75a47195c132b679cb8389a27bfc6c308b6d88c583c4329645eba11d68f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b30b75a47195c132b679cb8389a27bfc6c308b6d88c583c4329645eba11d68f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4fb2adc7cf7d9709bf335bf74f37df1cc602f3ffb4bde407b93448a0a8d932"
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
