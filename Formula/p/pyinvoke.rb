class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
  sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36b794d28833e859d4b49b68adee4fcc82e96daef27c595ccc06963567c28e7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bf21dc50b60425c294d1a48e71521c04b7d3ef6bb4e55d09849f7a4facf9bdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bee3d1f8410b2d266c6ff62a41cbe082de8e9656c40a45b087f7fc7a60504725"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3d3e7f1ef7088e56273522b87288f75f9236b5164d0ea267af07a0c4f91ccc6"
    sha256 cellar: :any_skip_relocation, ventura:        "21c4fdad8cb5ca10ce09df5da8e7b49ed1e3b5a9d6e15bcb202178b9cd7de6f2"
    sha256 cellar: :any_skip_relocation, monterey:       "d30bafa0ec12cb1bdbfd0739e0659e130e442dd1758aa7aea2efe63e129e00ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ae78a41edb7a6ac2164226e1d23b411778ee6c8be011a8d9433b8a00d925d8"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
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
