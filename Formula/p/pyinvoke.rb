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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd344c952cc84ca26a60d956c247b3fb14b52e00361efd41c1bf70e350220d91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86673d4fe059d11933734acf43f671b653fd0195278c66d52ac8abbec6a998ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c020ca468cd9020b099df8bab9c17ea8126f98576d199430a6dfd61ad1bbd94"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e8ce934460c66273e213bbe989f64a0028ea7cbedbb86d98f1b2aca3792afc7"
    sha256 cellar: :any_skip_relocation, ventura:        "9c343ae486cd25d94a3b66ec8c4828fe7f6896e82e8769906744da414263e41a"
    sha256 cellar: :any_skip_relocation, monterey:       "35a68e0cf99d7869aeaa4c0c5e26dd65bf30144829512584952c6235b3e6e0a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ee356e6c29cbead91c18d814a4598d9470dd82fc879937ec57bc6825ebfe7c9"
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
