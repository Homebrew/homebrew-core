class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/35/14/1ec9742e151f3b06a723a20d9af7201a389ebd3aae8b7d93b521819489dc/Markdown-3.5.1.tar.gz"
  sha256 "b65d7beb248dc22f2e8a31fb706d93798093c308dc1aba295aedeb9d41a813bd"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1994fa6e4c06e2a89d55e7e336ac61753e3d1632a43483288765870999320317"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d487fe2d8b3c153ea16dc47bd6648983fc13a16f5ac33e843bc865e0ae8ad7cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b883598351adab39d58590ba101da1827969523c16f28c0fbfdc3f3e59ceeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "172f9272f7f96d142b34f06bf7c06bc23f1310cee694927ab3c658407248838c"
    sha256 cellar: :any_skip_relocation, ventura:        "35e2f8e84221e6e7a533f6567b937a717e78c7ab9414890d70ed81aaf61b45df"
    sha256 cellar: :any_skip_relocation, monterey:       "c1feaf593b22fe0a6d8eb0efe1d2675a4c919c7c7d1d71090b3e87c6ec0df4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0b4e0388dbf6565a80cb1db832a6778a97f7383bbd1f79013eeeee9ef613d9b"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import markdown;"
    end
  end
end
