class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://www.jefftk.com/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/refs/tags/release-2.0.9.tar.gz"
  sha256 "e6080e24982d749106b42bf62df9ad9010a6f85e557e3dbbe28deb781184167e"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1db5c0e424512c9a5300244b024b550fb68e9e6617ed39c26c5a07e6fec7e049"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "icdiff"
    bin.install "icdiff", "git-icdiff"
  end

  test do
    (testpath/"file1").write "test1"
    (testpath/"file2").write "test1"

    system bin/"icdiff", "file1", "file2"
    system "git", "init"
    system bin/"git-icdiff"
  end
end
