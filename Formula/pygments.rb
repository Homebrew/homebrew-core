class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/03/98/c7468f5a1b434cb15b1d240c5f3bd015962af8a822e89e7f10ee11e68928/Pygments-2.15.0.tar.gz"
  sha256 "f7e36cffc4c517fbc252861b9a6e4644ca0e5abadf9a113c72d1358ad09b9500"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "923cff2c9915d32be8372d429b30a58297c81f751e6a74c22c598573dbe308ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dafd66d36c599deef32b8307e2a66c3f7a37cdf9454ffc6990bf529aff0bbf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cc5e37b58c77087f0ab541f9d0b77d3454d37c50bffa325d46cd61775fc0bf0"
    sha256 cellar: :any_skip_relocation, ventura:        "995e2eee793e509b6115e594cd65a735e6ba69057542a6f40d787a185fb33b09"
    sha256 cellar: :any_skip_relocation, monterey:       "d27f32da8f94a03feca499a3d2a06a991e626c04225c01a9d8a9a3b5bfd57a09"
    sha256 cellar: :any_skip_relocation, big_sur:        "49a3d4f146ff04b8c80326f9a84d4e6cf5cf9dcb135ff226875b188b1d5ab8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f304af6acc8d1281debf45cc3ee108b8981bddadadff781447a3670529b3d001"
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
      system python_exe, "-m", "pip", "install", "--prefix=#{libexec}", "--no-deps", "."

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
