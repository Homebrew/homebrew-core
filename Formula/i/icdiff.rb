class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/refs/tags/release-2.0.7.tar.gz"
  sha256 "147ebdd0c2b8019d0702bbbb1349d77442a4f05530cba39276b58b005ca08c77"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "175b18450e5cb403f6b4efd527d638a9f852a6eb1074177e0d610a0c3c369b9f"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "icdiff"
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
