class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
  sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4c4ca02173cd7d45a5073e54cb7991df5c35d136107e86f9ed934c3966da1d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4e0d267ed304dcec06e7ae263ffe4d68a5cc6efed96b3f6d9f4762c284ea7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ef0097c5c6b6d9e8be9850348fc174ecc9d067a1c2a2996649ba8070efab527"
    sha256 cellar: :any_skip_relocation, ventura:        "47949f4685ff99283411f9f6e7b240d377f1083b1ba29f2360fcebcf7aa3c739"
    sha256 cellar: :any_skip_relocation, monterey:       "de61a6509ce2ea09784280ee603b0d6855488e88bf0d464f1683c3a0205a93ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e5417e2d615606e48d0e99043ee86729d937c37b53945afeb85755a8b4e7f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a43a0061420c032e0bd06fb36ca360332a5f2048ac6f5a6fc7f95ec64fd53d59"
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
