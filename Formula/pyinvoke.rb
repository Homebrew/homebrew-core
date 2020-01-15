class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/1.3.0.tar.gz"
  sha256 "f95915dfbadc0a5526946950160334bf476b282de285af0e7defdb712bb25d8b"
  revision 1
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72fa0ce37ad63f0ad409efe0bfea09e9ff32647cab0916b10a8a143705da0e5f" => :catalina
    sha256 "5f5d6d6de395b596f9fe65d166a61fcb8d2b24775dde2f9e5b4b44d86c2110e1" => :mojave
    sha256 "60857ae8855ac13fd79edc46985f825316bee7a5e25590367a45bda77dbc29a9" => :high_sierra
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
