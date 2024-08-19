class PythonPsutil < Formula
  desc "Cross-platform lib for process and system monitoring in Python"
  homepage "https://github.com/giampaolo/psutil"
  url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
  sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f6c374bc93d5a82d0f556f6e8037e34e12bc4dc638bd99c54d54942f20064b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "386de76866136c6178cdf61f0f2530d7c09e277df845769a4e0ff1827e796c3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fc189b27182662cb4a9ea82102ca990d6841540e6720589f7fe25f5e0a23f93"
    sha256 cellar: :any_skip_relocation, sonoma:         "0647cc0cf76c2efa7847939fb2a396cf14f754d24ea74c343a37e5cb264504ed"
    sha256 cellar: :any_skip_relocation, ventura:        "b7b3109f3a2e35f357dec03b4fec0ee329fdcb4dc70370fb2e5dcf3da0b3cd61"
    sha256 cellar: :any_skip_relocation, monterey:       "44795b00aa8ada3f3cad47b93f46833eb1d7f5fddd616e5b6b3de7901307e892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7291f9d5df62f0aad691acbcb8625d70899070b0b892c4fb9ebdf78b13d6b08"
  end

  disable! date: "2024-07-04", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      Additional details on upcoming formula removal are available at:
      * https://github.com/Homebrew/homebrew-core/issues/157500
      * https://docs.brew.sh/Python-for-Formula-Authors#libraries
      * https://docs.brew.sh/Homebrew-and-Python#pep-668-python312-and-virtual-environments
    EOS
  end

  test do
    pythons.each do |python|
      system python, "-c", "import psutil"
    end
  end
end
