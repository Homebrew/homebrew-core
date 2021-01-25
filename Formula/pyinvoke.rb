class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/f0/bf/12827f26d127549b0c17aeb075b8bec2b0a48873418c51fca4bfcd0bd985/invoke-1.5.0.tar.gz"
  sha256 "f0c560075b5fb29ba14dad44a7185514e94970d1b9d57dcd3723bec5fed92650"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "70f385b068f6f303a29679061c48b6e9adcf6db396bba3680f26d63d065d926c" => :big_sur
    sha256 "c1f2ddf912dcc04d8c2d29eb7ec303fc377664c3a6fe3a67ac556e8da34f9535" => :arm64_big_sur
    sha256 "b1b285e271f44c86c60c87a3891a3285f4c269ce4faba18b148bb28a7b7db5b8" => :catalina
    sha256 "685969f8e173f38d99e309231dc44be88c2431b6d2eda004e7c05bbf210802cd" => :mojave
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
