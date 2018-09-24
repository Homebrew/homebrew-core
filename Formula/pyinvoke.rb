class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/1.2.0.tar.gz"
  sha256 "266003d33a8b3a565268e33aa0f9767b9441cf1476a20258f929768ee5acd390"
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26244902d09b5b8b8b095d66012f87f9deef01048ba7609db255bfc1a84ffa36" => :mojave
    sha256 "030f74f8c1696a43428e3d274ae1ae829e9730353fd2880c67a6be99a19ec422" => :high_sierra
    sha256 "8f31465ff35f9b44aa37f66490ff1cf145cfb114033aec7fa8222583c7e90081" => :sierra
    sha256 "e2fc137f7335983a6162ea7af3cfa030dbb48dc61b55e08f24765bc5288a7745" => :el_capitan
  end

  depends_on "python@2"

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
