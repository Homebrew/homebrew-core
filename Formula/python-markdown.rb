class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/29/82/dfe242bcfd9eec0e7bf93a80a8f8d8515a95b980c44f5c0b45606397a423/Markdown-2.6.9.tar.gz"
  sha256 "73af797238b95768b3a9b6fe6270e250e5c09d988b8e5b223fd5efa4e06faf81"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f035a2d2740f243413f28430ce22610228712cae0fa9367f58564b5848eff63" => :high_sierra
    sha256 "6f035a2d2740f243413f28430ce22610228712cae0fa9367f58564b5848eff63" => :sierra
    sha256 "6f035a2d2740f243413f28430ce22610228712cae0fa9367f58564b5848eff63" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
