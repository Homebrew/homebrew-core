class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
  sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0244d25e686d6574fcaf35d14725a415c00b33dd0b2c697fc66a78160d9227a1"
  end

  depends_on "python@3.13" # Do not remove runtime dependency https://github.com/Homebrew/homebrew-core/issues/151248

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tasks.py").write <<~PYTHON
      from invoke import run, task

      @task
      def clean(ctx, extra=''):
          patterns = ['foo']
          if extra:
              patterns.append(extra)
          for pattern in patterns:
              run("rm -rf {}".format(pattern))
    PYTHON
    (testpath/"foo"/"bar").mkpath
    (testpath/"baz").mkpath
    system bin/"invoke", "clean"
    refute_path_exists testpath/"foo", "\"pyinvoke clean\" should have deleted \"foo\""
    assert_path_exists testpath/"baz", "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    refute_path_exists testpath/"foo", "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    refute_path_exists testpath/"baz", "pyinvoke clean-extra should have deleted \"baz\""
  end
end
