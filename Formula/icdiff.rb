class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-2.0.5.tar.gz"
  sha256 "e1c278222891acde5d5b47e31b89f765fdf022b8908057f583032530982fe5b4"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b001a77da2ef8aca46dafddd97e969893169fc6e3020098e5867cfc569aadaa8"
  end

  depends_on "python@3.11"

  def install
    rewrite_shebang detected_python_shebang, "icdiff"
    bin.install "icdiff", "git-icdiff"
  end

  test do
    (testpath/"file1").write "test1"
    (testpath/"file2").write "test1"
    system "#{bin}/icdiff", "file1", "file2"
    system "git", "init"
    system "#{bin}/git-icdiff"
  end
end
