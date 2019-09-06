class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/ac/df/0ae25a9fd5bb528fe3c65af7143708160aa3b47970d5272003a1ad5c03c6/Markdown-3.1.1.tar.gz"
  sha256 "2e50876bcdd74517e7b71f3e7a76102050edec255b3983403f1a63e7c8a41e7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "997125a0155bbebdc066d74272cfb4d7be2ebe1299204b1626db52d2a35ccd21" => :mojave
    sha256 "997125a0155bbebdc066d74272cfb4d7be2ebe1299204b1626db52d2a35ccd21" => :high_sierra
    sha256 "db626ba3ff3da1197a29fb621d15400790acf7e11d3adf9a5c022361f6554f3b" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
