class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "http://pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/0.22.1.tar.gz"
  sha256 "0ff243defb9dfdc45a869fb9cc50ba3c0590ef6b337f4df49c465f63911176fb"
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22caddb4a74b1d916fee0352c5ca99f4abe7f7544d5afa870d9d9b22442a8105" => :high_sierra
    sha256 "b649f689fa537171c909318338baa5147b4c6abe0e0d3ab4405bda9f9e433d3d" => :sierra
    sha256 "f6576a575d302c1549e7cf76d3d07f5fc0f5c38efdd3534e915c0a39f4de57f9" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
