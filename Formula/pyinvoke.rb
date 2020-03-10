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
    sha256 "1e1a631ba72c2a1796ea334071b4347c14f7274ee434f69142f7defde83ce65b" => :catalina
    sha256 "a1b6e87e50e74316445c4f1e7f31c2727740348074e671e61864b030bd086307" => :mojave
    sha256 "ee84ddb3d03af8d0826526e4d3cb3b5dc2968a8497b2478160b9ce7a0c37a57a" => :high_sierra
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
