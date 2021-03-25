class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-2.0.0.tar.gz"
  sha256 "bce07ff4995aafe9de274ca0a322e56275dc264948b125457d2cc73dd7e9eee2"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git"

  bottle :unneeded

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
