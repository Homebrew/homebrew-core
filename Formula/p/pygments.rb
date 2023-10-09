class Pygments < Formula
  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/d6/f7/4d461ddf9c2bcd6a4d7b2b139267ca32a69439387cc1f02a924ff8883825/Pygments-2.16.1.tar.gz"
  sha256 "1daff0494820c69bc8941e407aa20f577374ee88364ee10a98fdbe0aece96e29"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e68fc0b5c183c8d70ae822c4c43fb23c96b83597f09441deec159201115099f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18c118140c32d49d43069cea65725815e54252394030ebf7659f5524730b74a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823504e873f31ed10c71fb5f24c2b43f29598770d5229c3d8cdaa4714dd2f47d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7651e791931dfa84769c4e96c8127b37f705413e825af9f823fb3ab3ecdb658a"
    sha256 cellar: :any_skip_relocation, ventura:        "a132cfca099a65700f635bc0cf883d050d47c19b65fc62f58bb363c0e2d2317d"
    sha256 cellar: :any_skip_relocation, monterey:       "b2415f42c9fd536c2cfd30a43b778d02273a613ab06c963be626581b09be827f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d21d474ed493f0d9a5c373a51eecb677bc6ea75f864bc6744dd806923739fbcd"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
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
