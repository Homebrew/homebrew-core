class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "http://pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/0.21.0.tar.gz"
  sha256 "ca2fcc56e5abdb9e56c9c5222786356a825a2b552e0137dd06184c54ce9a1cde"
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccc0584694bc5803204bbd9d22645e335a30687a2661e031022929aec7c59be7" => :sierra
    sha256 "c76740efade8103fad62e669947d9f4479b77c0746e258eb23baa744c5875e42" => :el_capitan
    sha256 "8fb5e8e31df38d26d06e77bc81f7d6fcadba99288c3ef8ed0d5f92cca3e9539f" => :yosemite
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
