class Pycparser < Formula
  desc "C parser in Python"
  homepage "https://github.com/eliben/pycparser"
  url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
  sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "493634a14bdd3491626f9b76d04161cdaa045165fb8efffa9bf780efd823d844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "493634a14bdd3491626f9b76d04161cdaa045165fb8efffa9bf780efd823d844"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "493634a14bdd3491626f9b76d04161cdaa045165fb8efffa9bf780efd823d844"
    sha256 cellar: :any_skip_relocation, sonoma:         "493634a14bdd3491626f9b76d04161cdaa045165fb8efffa9bf780efd823d844"
    sha256 cellar: :any_skip_relocation, ventura:        "493634a14bdd3491626f9b76d04161cdaa045165fb8efffa9bf780efd823d844"
    sha256 cellar: :any_skip_relocation, monterey:       "493634a14bdd3491626f9b76d04161cdaa045165fb8efffa9bf780efd823d844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f591e2eca1cf20abf29c606294f0f8b1b2efde60a4cade17da0ea7440cfff7e"
  end

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
    pkgshare.install "examples"
  end

  test do
    examples = pkgshare/"examples"
    pythons.each do |python|
      system python, examples/"c-to-c.py", examples/"c_files/basic.c"
    end
  end
end
