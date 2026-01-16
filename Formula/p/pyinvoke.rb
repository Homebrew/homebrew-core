class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
  sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e0fd28c483546b397e1c2f3c95091200b89d1eb0ddd4970178c8e944f91095ab"
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
