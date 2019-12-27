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
    sha256 "f0d3437c7059392b0656e61aa598292f5de95a04dbf3a1b33497ad789cc797d9" => :catalina
    sha256 "c29ca3258dede2769616b5134911729b102b7de7101d157a4ce34afd73c2d16d" => :mojave
    sha256 "385bb92f31b81c09dbc329d2f5fcab8fbcfc8608a65cdf924eef23ed9ef38ed0" => :high_sierra
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
