class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/55/a2/763dc56e746ca013061b26c95868cb7f832c2a87dc27ed749641a734957f/invoke-1.7.0.tar.gz"
  sha256 "e332e49de40463f2016315f51df42313855772be86435686156bc18f45b5cc6c"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c658b67c5c75300ad6c9de3753943b807e545e62bb1024e74add694ad3634f20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c658b67c5c75300ad6c9de3753943b807e545e62bb1024e74add694ad3634f20"
    sha256 cellar: :any_skip_relocation, monterey:       "3f3952a15e8edb2422ebdcea9c4524df46ce45f1b4e0bacc5e1547995aec07c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f3952a15e8edb2422ebdcea9c4524df46ce45f1b4e0bacc5e1547995aec07c2"
    sha256 cellar: :any_skip_relocation, catalina:       "3f3952a15e8edb2422ebdcea9c4524df46ce45f1b4e0bacc5e1547995aec07c2"
    sha256 cellar: :any_skip_relocation, mojave:         "3f3952a15e8edb2422ebdcea9c4524df46ce45f1b4e0bacc5e1547995aec07c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2090caea6c04415c99277cc5c6fd9e9156015f3f4b390f34665eb2b8eeb6b847"
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
