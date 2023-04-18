class Icdiff < Formula
  include Language::Python::Shebang

  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-2.0.6.tar.gz"
  sha256 "8f79b82032696d2eea2a3acf722cd34cf45215d4b09b52139880626a2b0d360e"
  license "PSF-2.0"
  head "https://github.com/jeffkaufman/icdiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "761b406100bafad194eaf0fd5f699be0c7676b34aaa2d6f07665e03cdeede2f5"
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
