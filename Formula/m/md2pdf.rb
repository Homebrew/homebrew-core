class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/mdtopdf"
  url "https://github.com/solworktech/mdtopdf/archive/refs/tags/v2.2.13.tar.gz"
  sha256 "e973b25d84a233848d4c839e1f0e18b22dee23f5774a59b8789b081638bd60e0"
  license "MIT"
  head "https://github.com/solworktech/mdtopdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe15170715e7929a4f32c28cf8fdc869074e1d61f6686015c038c70df0f30643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe15170715e7929a4f32c28cf8fdc869074e1d61f6686015c038c70df0f30643"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe15170715e7929a4f32c28cf8fdc869074e1d61f6686015c038c70df0f30643"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe47f4128efb7f929da33f2b4517d74be49b04a9d6de441bdc4e5219782fb124"
    sha256 cellar: :any_skip_relocation, ventura:       "fe47f4128efb7f929da33f2b4517d74be49b04a9d6de441bdc4e5219782fb124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "795b3c1070eaaa6c22d9ba0d8c4a42023b399db5a03cc26897bf92ce192fe94f"
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
