class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/37/b3/0b88358ee07789688d17ec7074a656da68ced50a122183187be12928b535/invoke-1.6.0.tar.gz"
  sha256 "374d1e2ecf78981da94bfaf95366216aaec27c2d6a7b7d5818d92da55aa258d3"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5299fac1aede1c601d70315a6c50877286372e3a57b41c6be1afeee3039f25d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2603322a31663ae178003c4df6c6b22e9623a870244231288f5bfc8404e1eb9"
    sha256 cellar: :any_skip_relocation, catalina:      "a2603322a31663ae178003c4df6c6b22e9623a870244231288f5bfc8404e1eb9"
    sha256 cellar: :any_skip_relocation, mojave:        "a2603322a31663ae178003c4df6c6b22e9623a870244231288f5bfc8404e1eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7347fdf05d5924430baa47e9936cda6d96f7c873200c7516fa81ac9888938339"
  end

  depends_on "python@3.9"

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
