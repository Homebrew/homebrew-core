class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/md2pdf"
  url "https://github.com/solworktech/md2pdf/archive/refs/tags/v2.2.21.tar.gz"
  sha256 "7808fa6d19643889feb058a3cb4fcca85d6872722f8800eed1c62e4877086858"
  license "MIT"
  head "https://github.com/solworktech/md2pdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b0ac684acd454bc7ee53ac24197a0c9ef8874bab32cc4f3977f6f1d16b5cbdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0ac684acd454bc7ee53ac24197a0c9ef8874bab32cc4f3977f6f1d16b5cbdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b0ac684acd454bc7ee53ac24197a0c9ef8874bab32cc4f3977f6f1d16b5cbdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "452c48ae6b8d7fc761588d635d2feb455c261218fca33ccfb57215eeaeaa05bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b863c2ed471711355e8057e5ca10eb9115a6f6f946d428498a71e5fcbd5975c"
    sha256 cellar: :any,                 x86_64_linux:  "4659041027d612b44c85b5819226271734df8ea904da25264c9248498388ab4d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/md2pdf"
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
