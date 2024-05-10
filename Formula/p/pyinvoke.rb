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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df2155441e4e061f37e689d85347985bcf4dcb032685c71e323295fa566206a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44223d17b48a193c0959da9166dc99540aeab74d3bcd57017fc4d9a5e8a2e2de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "580d8ddd06ff9702d3bb980134429063cfc926fb1736a2de8b51fef7477f84a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1e42032921d548303bebd7e73a7ebd744165eb359999612318f79afa4e1bcd3"
    sha256 cellar: :any_skip_relocation, ventura:        "0e830d28a12412a870e23aa4c62eedce6039fd47fe7d487477ed7ac18b57fcc0"
    sha256 cellar: :any_skip_relocation, monterey:       "543b5775c3bd0dce958677e4b8a0c2def17f0dbcb7106122009bc29cce8ac65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe4609148305d8681c69364a413beba43a244ea7bc26de56d07607cd6536330"
  end

  depends_on "python@3.12" # Do not remove runtime dependency https://github.com/Homebrew/homebrew-core/issues/151248

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tasks.py").write <<~EOS
      from invoke import run, task

      @task
      def clean(ctx, extra=''):
          patterns = ['foo']
          if extra:
              patterns.append(extra)
          for pattern in patterns:
              run("rm -rf {}".format(pattern))
    EOS
    (testpath/"foo"/"bar").mkpath
    (testpath/"baz").mkpath
    system bin/"invoke", "clean"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean\" should have deleted \"foo\""
    assert_predicate testpath/"baz", :exist?, "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    refute_predicate testpath/"baz", :exist?, "pyinvoke clean-extra should have deleted \"baz\""
  end
end
