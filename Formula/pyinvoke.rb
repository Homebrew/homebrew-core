class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/1.2.0.tar.gz"
  sha256 "266003d33a8b3a565268e33aa0f9767b9441cf1476a20258f929768ee5acd390"
  revision 1
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b542b3b704df6c5426c73b0eb5bb488450e98eabcb732acbaf2b5efc65e0b971" => :catalina
    sha256 "381a13898c676f211ae0866eda70d51d4b500fa470e198c9cb32a57483f71b71" => :mojave
    sha256 "6f242a9c102fbd1e02c86e7c5e26eb4053b5ef50c9d0530393158662998538e6" => :high_sierra
    sha256 "e581b8aade463fae2f82209a2ef250cbaa5c346c6826b13770141b3551457d34" => :sierra
  end

  depends_on "python"

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
