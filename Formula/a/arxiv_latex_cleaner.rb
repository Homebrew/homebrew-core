class ArxivLatexCleaner < Formula
  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/38/fb/139464323ae1f8c623b0b61c21d276264c009b3908b3af541408d0044234/arxiv_latex_cleaner-1.0.3.tar.gz"
  sha256 "c2a0996c5c4bebfd91fed0cb16b16644856b9221574c8a1326069de80d1edf92"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2664e03fcfdbdeda9f2527bac4659fd01cdb5b100b720ce6c8640a05dcfaad74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66007a412fb318084bfca2a593ee1f541f61efbeaf8c4dfd23a25cab422228af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f1b10d9ac0f1da0d1d31ba47bbe9c3ccdc3ec0d7641f71f2c9fe6c214c67d0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "83924767dde4297d8bd2f65d2ad7d1ce1afb71cfabc7340c05e8c9a1431820bd"
    sha256 cellar: :any_skip_relocation, ventura:        "8eed6cd727cd44c958182d869b406fdb733b66a7fd6112cd1de02ac6197b1d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "a6f2d7c4e98cdf3280532020d80c091ecf37deb4a5162672f5b06e52a8d91a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7af0a8e674d707650f99c40c7d88fed6a069e4feebde4cb44eb9648810aa48c"
  end

  depends_on "python-setuptools" => :build
  depends_on "pillow"
  depends_on "python-abseil"
  depends_on "python-regex"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
