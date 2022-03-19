class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/55/a2/763dc56e746ca013061b26c95868cb7f832c2a87dc27ed749641a734957f/invoke-1.7.0.tar.gz"
  sha256 "e332e49de40463f2016315f51df42313855772be86435686156bc18f45b5cc6c"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "100b3b1049f44efc6df39b9fed12d7f4ec81ce2ffa900b9cca21d49e87b3c3ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "100b3b1049f44efc6df39b9fed12d7f4ec81ce2ffa900b9cca21d49e87b3c3ea"
    sha256 cellar: :any_skip_relocation, monterey:       "3574a1c728a3641db90d5f48b6419a9338a30f9fae086d274affd8612281ffd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3574a1c728a3641db90d5f48b6419a9338a30f9fae086d274affd8612281ffd5"
    sha256 cellar: :any_skip_relocation, catalina:       "3574a1c728a3641db90d5f48b6419a9338a30f9fae086d274affd8612281ffd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d778e5dd3cc91de682f597593c7c4af5d8c7017cc263bc59693dd9947d7cfd5"
  end

  depends_on "python@3.10"

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
