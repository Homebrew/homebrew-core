class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"
  sha256 "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"

  bottle do
    cellar :any_skip_relocation
    sha256 "88c387a1bf72eb8099a9f28e97696944ab406a002495b53099ac54de2a4efe93" => :high_sierra
    sha256 "88c387a1bf72eb8099a9f28e97696944ab406a002495b53099ac54de2a4efe93" => :sierra
    sha256 "88c387a1bf72eb8099a9f28e97696944ab406a002495b53099ac54de2a4efe93" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
