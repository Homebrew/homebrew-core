class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/2b/8d/9aec496bbd200589397b4cd6d546576c296465c1bdeb28c1ea1019e75a1f/invoke-1.7.3.tar.gz"
  sha256 "41b428342d466a82135d5ab37119685a989713742be46e42a3a399d685579314"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "029a95b94fb67fc2cd1dbac8d5d1d5a4fa4e4f2f73bdfae884bc307f7d1df70b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c01767e4889359070893a059ab2acc918346363656a7327c94af44946de0d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c01767e4889359070893a059ab2acc918346363656a7327c94af44946de0d7"
    sha256 cellar: :any_skip_relocation, ventura:        "a4b53d71501ce6bc3cae2149c95df1fab67ce935d175914160d5169a920fa316"
    sha256 cellar: :any_skip_relocation, monterey:       "e1d00d88a499551112ae26e7d9ab802c22cd67fcbcf0905440268de4854e086d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1d00d88a499551112ae26e7d9ab802c22cd67fcbcf0905440268de4854e086d"
    sha256 cellar: :any_skip_relocation, catalina:       "e1d00d88a499551112ae26e7d9ab802c22cd67fcbcf0905440268de4854e086d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92637a30e8c01405910a515b2fc8480c30438cef6a20e9bac366f93529f8dbb8"
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
