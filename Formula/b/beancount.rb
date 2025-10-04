class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/57/e3/951015ad2e72917611e1a45c5fe9a33b4e2e202923d91455a9727aff441b/beancount-3.2.0.tar.gz"
  sha256 "9f374bdcbae63328d8a0cf6d539490f81caa647f2d1cc92c9fa6117a9eb092ca"
  license "GPL-2.0-only"
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c750707d300e487491fed0b5a2ff88b78df1d7fef866552a6884c223adcf9f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c559f601f19b561b3eb3ae3b2a9cf22511b4be6895cb350acd685e8d13b7a9bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51d6e039e81485469e531542d57bc0a6c9b554f614442fc2e2c4eea1913b58dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "22f1ae329348e602ab3f8a1773a2cd347ef06d0a2f89df2d4906198a2b56c5ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2670a74f924ad5b3e85a0ed011fcc2d5cba007bbfe40ce9434e167bd7397ad88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb6cbb17687b4ad50f6048f4cec295605170fa74cc1bd4ab9c54cd65b1ed24ce"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "flex" => :build
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b2/5a/4c63457fbcaf19d138d72b2e9b39405954f98c0349b31c601bfcb151582c/regex-2025.9.1.tar.gz"
    sha256 "88ac07b38d20b54d79e704e38aa3bd2c0f8027432164226bdee201a1c0c9c9ff"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    bin.glob("bean-*") do |executable|
      generate_completions_from_executable(executable, shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"example.ledger").write shell_output("#{bin}/bean-example").strip
    assert_empty shell_output("#{bin}/bean-check #{testpath}/example.ledger").strip
  end
end
