class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://www.jefftk.com/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/refs/tags/release-2.0.10.tar.gz"
  sha256 "0db463ddf9006c671170022cae2ce6ef101b0da6329ab59ae90a534ef57fea5e"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0983cc614b2109d7aab7d91987c091341e27c51a4dae4e5aecca3decf6602e39"
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
