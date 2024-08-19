class Ly < Formula
  desc "Parse, manipulate or create documents in LilyPond format"
  homepage "https://github.com/frescobaldi/python-ly"
  url "https://files.pythonhosted.org/packages/9b/ed/e277509bb9f9376efe391f2f5a27da9840366d12a62bef30f44e5a24e0d9/python-ly-0.9.7.tar.gz"
  sha256 "d4d2b68eb0ef8073200154247cc9bd91ed7fb2671ac966ef3d2853281c15d7a8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df85e596fb8395cd8c575119c06782cc810f2c0eb6e56346405abafa27261049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3534a360741817550ae8894d2c66dbdf10cff8686d31af9356f8f340a3bba7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19729d3a97e1e59649bbb87cbb1bfd3e229b49a272ddd9ac3326f3fa418acbcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "aefa53aaf960773f6de1b7e3c311ba24677dce3c1b1d12b92f2f0ff214bfe17a"
    sha256 cellar: :any_skip_relocation, ventura:        "2196916f24a90582f44f8c4a62e4c493ed78d0c3f59ca09006b9679880d6f961"
    sha256 cellar: :any_skip_relocation, monterey:       "34fac2386f66074e772e566cc9afedfe0002a7b2f72b1e45401d105071ffaa9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58025ba773b81b7d22e72c002f9ce7ed7691bf6f51d10ed8d60bf065ac330ff8"
  end

  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    output = shell_output "#{bin}/ly 'transpose c d' #{testpath}/test.ly"
    assert_equal "\\relative { d' e fis g a b cis d }", output

    system python3, "-c", "import ly"
  end
end
