class Ly < Formula
  desc "Parse, manipulate or create documents in LilyPond format"
  homepage "https://github.com/frescobaldi/python-ly"
  url "https://files.pythonhosted.org/packages/94/a2/c21c90a3790612521feca435e1019eae6edc6a15084aab91b13b47a7486c/python_ly-0.9.10.tar.gz"
  sha256 "18ef058b4d0fa235768b6669041174370f553d6c84eb7a4495f95bb315e0f18a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db74913f3293f2a0cde5225ab3721c7ce2682f7eaa896e843426717fc525b730"
  end

  depends_on "python@3.14"

  def python3
    "python3.14"
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
