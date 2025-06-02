class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/mdtopdf"
  url "https://github.com/solworktech/mdtopdf/archive/refs/tags/v2.2.16.tar.gz"
  sha256 "6c9f94648cdd6fbddb9719fe79ef18a7fca6a4588989427ea84c35d43cbf8369"
  license "MIT"
  head "https://github.com/solworktech/mdtopdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38982081b8951bc2505e6156607882169a8d9fa2fb8d087c6d2f7530af16c102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38982081b8951bc2505e6156607882169a8d9fa2fb8d087c6d2f7530af16c102"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38982081b8951bc2505e6156607882169a8d9fa2fb8d087c6d2f7530af16c102"
    sha256 cellar: :any_skip_relocation, sonoma:        "6222a9cd2dd2d14522f4c59473ecd97f933805c9edfea9762b9877470a85e549"
    sha256 cellar: :any_skip_relocation, ventura:       "6222a9cd2dd2d14522f4c59473ecd97f933805c9edfea9762b9877470a85e549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4b31544cee7ed7e431999f9b4e5c9a9fbd3cc7f219fd5785801b9b17be9a82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/md2pdf"
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
      This is a test markdown file.
    MARKDOWN

    system bin/"md2pdf", "-i", "test.md", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
