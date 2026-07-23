class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
  sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f46e5217b0e3117c9baea206c276c7b87fb6b1f02ce17940cd3c4789b0f3d54b"
  end

  depends_on "python@3.14" # Do not remove runtime dependency https://github.com/Homebrew/homebrew-core/issues/151248

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
    (testpath/"foo/bar").mkpath
    (testpath/"baz").mkpath
    system bin/"invoke", "clean"
    refute_path_exists testpath/"foo", "\"pyinvoke clean\" should have deleted \"foo\""
    assert_path_exists testpath/"baz", "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    refute_path_exists testpath/"foo", "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    refute_path_exists testpath/"baz", "pyinvoke clean-extra should have deleted \"baz\""
  end
end
