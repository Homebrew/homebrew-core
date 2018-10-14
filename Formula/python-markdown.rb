class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"
  sha256 "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "923867169d4ade0ee1db1ad297587fc5f8f2067c5cb1610ea96d2f50d9fe0025" => :mojave
    sha256 "06ed36407b1575cfd06f0252bdf1d6985ed338491c9737803827a1a6cd3e5998" => :high_sierra
    sha256 "06ed36407b1575cfd06f0252bdf1d6985ed338491c9737803827a1a6cd3e5998" => :sierra
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
