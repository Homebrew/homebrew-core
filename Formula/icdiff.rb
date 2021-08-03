class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-2.0.3.tar.gz"
  sha256 "23e9502895999a929e1d3559403205846742f7cf8a22c5d7f3c4db910ba12321"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6527bb074c26002e16e014b6e887549a9303dad523ffee000229907360130e43"
  end

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "icdiff"
    bin.install "icdiff", "git-icdiff"
  end

  test do
    (testpath/"file1").write "test1"
    (testpath/"file2").write "test2"
    system "#{bin}/icdiff", "file1", "file2"
    system "git", "init"
    system "#{bin}/git-icdiff"
  end
end
