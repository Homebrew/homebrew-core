class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "http://pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/0.19.0.tar.gz"
  sha256 "3b25c3618cc5c86236eb73f94780a55846aff88351e914eab276210900402289"
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d328e92c7dd4927e2cf46ce8ef0df038ceb3f19f70f7473ed7779e8677e9126b" => :sierra
    sha256 "09327aeceb660ce17d06c887e443f58babb3074e43f5d0e695a28104f9c3faa6" => :el_capitan
    sha256 "1c1fb1f4fd0cadfb4ab114c0e211f479d159152015fdab6bb2f28fc689d10b0b" => :yosemite
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
