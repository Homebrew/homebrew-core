class Ly < Formula
  desc "Parse, manipulate or create documents in LilyPond format"
  homepage "https://github.com/frescobaldi/python-ly"
  url "https://files.pythonhosted.org/packages/9b/ed/e277509bb9f9376efe391f2f5a27da9840366d12a62bef30f44e5a24e0d9/python-ly-0.9.7.tar.gz"
  sha256 "d4d2b68eb0ef8073200154247cc9bd91ed7fb2671ac966ef3d2853281c15d7a8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "24173bdbfe1917ec3bef8bfb63419436c863e15729f8d128e54ed71af4cd2f21"
  end

  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    output = shell_output("#{bin}/ly 'transpose c d' #{testpath}/test.ly")
    assert_equal "\\relative { d' e fis g a b cis d }", output

    system python3, "-c", "import ly"
  end
end
