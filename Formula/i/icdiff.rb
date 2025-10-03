class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://www.jefftk.com/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/refs/tags/release-2.0.7.tar.gz"
  sha256 "147ebdd0c2b8019d0702bbbb1349d77442a4f05530cba39276b58b005ca08c77"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "6fd6d50bbd97cdad70b01dcbb90a65b87f79a359cbe235f0d23367de8778fbfc"
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
