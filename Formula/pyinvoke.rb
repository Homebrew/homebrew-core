class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "http://pyinvoke.org/"
  url "https://github.com/pyinvoke/invoke/archive/0.20.1.tar.gz"
  sha256 "892f1e7988f919ecad3511e57ee6766d31553582c3ca27c84708f12cb24c05a3"
  head "https://github.com/pyinvoke/invoke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75ece9c7ed2b85df8f3bb063bda05807a30a17cc552a937c8c5d24fa8569f94c" => :sierra
    sha256 "086cb088021b701dbb6e2203ec489db8e4149e146179bcee1a601f5343308aa4" => :el_capitan
    sha256 "9136f6fdcd0808e60b0c935922e25f05229e89a4cba62f1c528da6923ada98db" => :yosemite
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
