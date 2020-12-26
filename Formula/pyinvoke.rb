class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/b6/08/b345475cfaaa542ae78a172d5b23979ad0577f15a32b16e5e54b2a7e80c6/invoke-1.4.1.tar.gz"
  sha256 "de3f23bfe669e3db1085789fd859eb8ca8e0c5d9c20811e2407fa042e8a5e15d"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/pyinvoke/invoke.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1cd69f9ee6ef73e26b781a7c8260ce80e430a56d2362054ba610e2a783265837" => :big_sur
    sha256 "0b2b7154448f93609c3e1706ea58ab3a9483bb8845aea80e6830ed59e02ba2dc" => :arm64_big_sur
    sha256 "eccd4bc025f6e8aeb6239105bdd2054d33b19a26070ed5980d3797f1f7d05ee1" => :catalina
    sha256 "b1ae4b3f79dfb446e8d7ca9786fd64af088797b37fea00a093cc032c4aac02f6" => :mojave
    sha256 "2cbd9d88b790af9d6f43e854481a5956e614a6d69d229911530cdffdaeba9cba" => :high_sierra
  end

  depends_on "python@3.9"

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
