class Pygments < Formula
  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/d6/f7/4d461ddf9c2bcd6a4d7b2b139267ca32a69439387cc1f02a924ff8883825/Pygments-2.16.1.tar.gz"
  sha256 "1daff0494820c69bc8941e407aa20f577374ee88364ee10a98fdbe0aece96e29"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ecca40468305b9bd549304602d0176e8d1044747d5c7ffb79437fc6fddf87f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "559c9e5f2e02ab5f1ba7d613a8b34db2f838e1858feede8c9fd56128006522e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d8285e8c7c2560f5243fff90ea564d5807017ae6c1f838a089050e663ddd31a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae6cc81c275c2daa061d02a455f847441cdc697d0c6ec7b64ec93ac36458cbf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "acff66631301feaf360a518836ece23e29a639145666e04fec55dfcf1ac4cd04"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b4aad08fe4fdc54e10fef060779e40cb41a24a552fd99c3d23374fd6c517b6"
    sha256 cellar: :any_skip_relocation, monterey:       "e17fb3c825ecd89faf79ae8f84f3e0224a6c5aab9daffe65475ba14e49aa4601"
    sha256 cellar: :any_skip_relocation, big_sur:        "a40200bae52d000af9c9b83c2fce97f9508e627cec7b3410227234ad8f8a1693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5931cbf1c8329172ba638a022190b042ae9eab47b141a43148c811928432ea"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.select { |dep| dep.name.start_with?("python") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install bin/"pygmentize" => "pygmentize-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pygmentize-#{pyversion}" => "pygmentize"
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      system bin/"pygmentize-#{pyversion}", "-f", "html", "-o", "test.html", testpath/"test.py"
      assert_predicate testpath/"test.html", :exist?

      (testpath/"test.html").unlink

      next if python != pythons.max_by(&:version)

      system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
      assert_predicate testpath/"test.html", :exist?
    end
  end
end
