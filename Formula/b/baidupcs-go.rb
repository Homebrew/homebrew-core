class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "12904ec8daee445b357f59d604103108a324f5b1c60cb0d8324f5df216683553"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64f9017b324cdbf7a9d368bf9f13d90fcb2c2056e9098d4e2b107e96eb4fbe6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64f9017b324cdbf7a9d368bf9f13d90fcb2c2056e9098d4e2b107e96eb4fbe6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64f9017b324cdbf7a9d368bf9f13d90fcb2c2056e9098d4e2b107e96eb4fbe6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bbad39dbd0118744efd70d72f72e410a9e1429a214d425411464cac92cde99b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa3595b2563ee35651eee593e29507d7e6c4958e5aed2ea8cd0af25296977f5"
    sha256 cellar: :any,                 x86_64_linux:  "1e69dc1a0b80715c987b867529e9689108d88ae0170f16f2e4d7d336f8fe6e02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_path_exists testpath/"test.txt"
  end
end
