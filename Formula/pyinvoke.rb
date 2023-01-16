class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/43/59/42a4d8336c01a8df19e62b25949b551f9d3dc0d4292eea25eddacc9e329e/invoke-2.0.0.tar.gz"
  sha256 "7ab5dd9cd76b787d560a78b1a9810d252367ab595985c50612702be21d671dd7"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4254961d8b57fe582e30b38b4e39ea0d8ea53401a1a485511ae12f2c545c94b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4254961d8b57fe582e30b38b4e39ea0d8ea53401a1a485511ae12f2c545c94b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4254961d8b57fe582e30b38b4e39ea0d8ea53401a1a485511ae12f2c545c94b"
    sha256 cellar: :any_skip_relocation, ventura:        "191044f6ed007f1ed00dfe9b6b35f1a58df53850ba341dd37c8b64b7dfdabda0"
    sha256 cellar: :any_skip_relocation, monterey:       "191044f6ed007f1ed00dfe9b6b35f1a58df53850ba341dd37c8b64b7dfdabda0"
    sha256 cellar: :any_skip_relocation, big_sur:        "191044f6ed007f1ed00dfe9b6b35f1a58df53850ba341dd37c8b64b7dfdabda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "808c3ca90ec453fe65718449286422063d57e342f08a06cdf38d49799115d162"
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
