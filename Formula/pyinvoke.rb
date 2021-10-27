class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/37/b3/0b88358ee07789688d17ec7074a656da68ced50a122183187be12928b535/invoke-1.6.0.tar.gz"
  sha256 "374d1e2ecf78981da94bfaf95366216aaec27c2d6a7b7d5818d92da55aa258d3"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/pyinvoke/invoke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c658b67c5c75300ad6c9de3753943b807e545e62bb1024e74add694ad3634f20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c658b67c5c75300ad6c9de3753943b807e545e62bb1024e74add694ad3634f20"
    sha256 cellar: :any_skip_relocation, monterey:       "3f3952a15e8edb2422ebdcea9c4524df46ce45f1b4e0bacc5e1547995aec07c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f3952a15e8edb2422ebdcea9c4524df46ce45f1b4e0bacc5e1547995aec07c2"
    sha256 cellar: :any_skip_relocation, catalina:       "3f3952a15e8edb2422ebdcea9c4524df46ce45f1b4e0bacc5e1547995aec07c2"
    sha256 cellar: :any_skip_relocation, mojave:         "3f3952a15e8edb2422ebdcea9c4524df46ce45f1b4e0bacc5e1547995aec07c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2090caea6c04415c99277cc5c6fd9e9156015f3f4b390f34665eb2b8eeb6b847"
  end

  depends_on "python@3.10"

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
