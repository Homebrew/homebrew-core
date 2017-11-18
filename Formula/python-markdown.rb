class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/29/82/dfe242bcfd9eec0e7bf93a80a8f8d8515a95b980c44f5c0b45606397a423/Markdown-2.6.9.tar.gz"
  sha256 "73af797238b95768b3a9b6fe6270e250e5c09d988b8e5b223fd5efa4e06faf81"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3e06a910f9bdc55265f2d5242577742394dfd081fae200da6faa5214d957fdf" => :high_sierra
    sha256 "4673d2636e4327ee243f52fda84ba374b536cebf347cff430106b28a4d799f20" => :sierra
    sha256 "ed951b7e851bdbf329a9718aea5b71b9ba0c49c1bb2898a81fcf095ccef00d33" => :el_capitan
    sha256 "629aa5a47ad91c7d43d016129ec5acb20d535840975d606241a38d7fe8961a4b" => :yosemite
    sha256 "2b0f3ce418e7e695f1e1d00d9b31abb61704b8a41761387bdc290e07202e308e" => :mavericks
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
