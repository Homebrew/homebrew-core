class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/df/59/41b614b9d415929b4d72e3ee658bd088640e9a800e55663529a8237deae3/invoke-1.7.1.tar.gz"
  sha256 "7b6deaf585eee0a848205d0b8c0014b9bf6f287a8eb798818a642dff1df14b19"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392d78217312b728482857432048b90a8fde1793a530453137ac3b735fee518d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "392d78217312b728482857432048b90a8fde1793a530453137ac3b735fee518d"
    sha256 cellar: :any_skip_relocation, monterey:       "824d5bbe3056db0e176a10a5aa2ad8062f6efe77e492c1394aeca8d6c072f9ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "824d5bbe3056db0e176a10a5aa2ad8062f6efe77e492c1394aeca8d6c072f9ce"
    sha256 cellar: :any_skip_relocation, catalina:       "824d5bbe3056db0e176a10a5aa2ad8062f6efe77e492c1394aeca8d6c072f9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5df852536a802c027346bbb2e799d8513aa75eac316b7b156ff2127b273fee99"
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
