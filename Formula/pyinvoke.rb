class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/46/37/0c5e8d33773e55fc265d80d87bb0e78b353a447d6702ba72584536b9cf9d/invoke-2.1.3.tar.gz"
  sha256 "a3b15d52d50bbabd851b8a39582c772180b614000fa1612b4d92484d54d38c6b"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e51e6c7dd41652ed8539aa72f8f081a01b5ef6a49ac9fd382330579971eb1b04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f7aef3a35f957764ef64c967f5d0544be6394f4e5ac51d358e4a1c8c9c38927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15cf995d37ddb993a599163bafea4a43c78c62fe3b85b5856bb89db51ee610ae"
    sha256 cellar: :any_skip_relocation, ventura:        "33961e6e1f02375e979463e1944f5fc2f8f135d17944ae60917cadde4ec6f724"
    sha256 cellar: :any_skip_relocation, monterey:       "f1442266e74aef8abfee416eee942761b9c0263ab0bfc83e353b3fe7fcafb244"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5733a98659441ddc86982cc8dcb17d2b577dd46c06fb6286c66c19d32799a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f01edf227254cf3f9d0fcbcd834a5ceb9c9eab43581b61736a34e6af97ed20f7"
  end

  depends_on "python@3.11"

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
