class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
  sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c44f5496e7479ed4e0e020185e2601c4a4d8c16b3e2b88c2a6352c89cd79bb2"
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
      system python_exe, *Language::Python.setup_install_args(libexec, python_exe)

      site_packages = Language::Python.site_packages(python_exe)
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-pygments.pth").write pth_contents

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install libexec/"bin/pygmentize" => "pygmentize-#{pyversion}"

      next unless python == pythons.max_by(&:version)

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

      next unless python == pythons.max_by(&:version)

      system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
      assert_predicate testpath/"test.html", :exist?
    end
  end
end
