class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-2.0.4.tar.gz"
  sha256 "ec21632b64159990a1bcedc8b25f96b476e7a6d9e18b75422420c0ae9b694eac"
  license "PSF-2.0"
  revision 1
  head "https://github.com/jeffkaufman/icdiff.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc5be5fa45223aa9fd58fa6230a7e15c65a1878b94add36c62328f5295438b8e"
  end

  depends_on "python@3.10"

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
