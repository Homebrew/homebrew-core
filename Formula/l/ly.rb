class Ly < Formula
  desc "Parse, manipulate or create documents in LilyPond format"
  homepage "https://github.com/frescobaldi/python-ly"
  url "https://files.pythonhosted.org/packages/b6/25/d82a762b4c8f068303259f9555fe6f8725f930318a64679a6bb9ffdf21c8/python_ly-0.9.9.tar.gz"
  sha256 "cf1780fe53d367efc1f2642cb77c57246106ea7517f8c2d1126f0a36ee26567a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a28dcdb3270423db13b9b8eb52ef1b65beffa23cd684672e6ebfa8b992cd413"
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
