class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-2.0.7.tar.gz"
  sha256 "147ebdd0c2b8019d0702bbbb1349d77442a4f05530cba39276b58b005ca08c77"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac4a9539ee17dd4f7391649e9c438ed288367a59a8adc11869ac94f2a0bdc9de"
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
