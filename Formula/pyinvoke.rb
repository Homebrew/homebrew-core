class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "http://pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/0.20.3.tar.gz"
  sha256 "44f2d71e7c1a993a71b1b242e4681af5cd30e880f13671561794926497ac93dc"
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "169475314a4c2a487a5314a03836d700fb0c96ef027ca4c3518bd77dff543b3b" => :sierra
    sha256 "1c901b79b22fbeb525b83fe52e0ecaa02b749c9af0d28122dfde2643ea78fcac" => :el_capitan
    sha256 "3f554eb9f1926a2b04cd8fd8ff35052bba54aeb5b78050b88a0a327ee94282e3" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tasks.py").write <<-EOS.undent
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
    assert !File.exist?(testpath/"foo"), "\"pyinvoke clean\" should have deleted \"foo\""
    assert File.exist?(testpath/"baz"), "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    assert !File.exist?(testpath/"foo"), "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    assert !File.exist?(testpath/"baz"), "pyinvoke clean-extra should have deleted \"baz\""
  end
end
