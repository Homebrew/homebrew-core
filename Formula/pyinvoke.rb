class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/1.4.1.tar.gz"
  sha256 "ac5880fb5d21f06cc1b29f89736cb8a43b85abea9204b4bb4277458ae025d0b7"
  revision 1
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e576690387b7433b3795c926672cebc76f51c1a78d64798db3a9b4fba2a584e" => :catalina
    sha256 "576bd35748ea63fcc0a8bd6f42e68755e34c3736b5233adb0f86293dcaf912f3" => :mojave
    sha256 "44224c0c6d1c175ddccf9bc20dcc6a0b3c48bd7ab72a30fde8f40db055406eee" => :high_sierra
  end

  depends_on "python@3.8"

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
