class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/f0/68/d7d5503adbd302fb8e44c8ece2b8afff467a888efb8a0a116c432cc4f4fe/Markdown-2.6.10.zip"
  sha256 "cfa536d1ee8984007fcecc5a38a493ff05c174cb74cb2341dafd175e6bc30851"

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
