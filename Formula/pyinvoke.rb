class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/c6/58/dc1e7a70fed3eea19643125a2bfd0dc01621e4d5d31e5afb64ef4d69f633/invoke-2.1.2.tar.gz"
  sha256 "a6cc1f06f75bacd0b1e11488fa3bf3e62f85e31f62e2c0172188613ba5b070e2"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec7662d40ca14cde0577e7a591492a8419c65d9ee3b26593c7e017446cd9d1eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d174d43e50910fbaec14d47c5fa0a4b65976e5c28c013e2b4fab503eb1b6b47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7564216a30b541cb8fd264d5c691e501abdf2e06ff3c2825bcb2e1b19cea2ec9"
    sha256 cellar: :any_skip_relocation, ventura:        "3eea8720fa7f35435039872d275a031524f46b9fd3fa4f6ec86dfeb645248265"
    sha256 cellar: :any_skip_relocation, monterey:       "5b0354a83fc53980dcf9c2a93cb32831a787c33c8f93d0ed28957b30d0e9c582"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d2dcb49c666a802daed8e5cfcb42d7befc3462c5e63d2e98983c839838a4526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5433e0406279dd1c623ed56dc1a0f6925b99327f749b8ba3e9e917fdb4f7b8"
  end

  depends_on "python@3.11"

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
