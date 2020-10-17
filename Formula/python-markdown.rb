class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://github.com/Python-Markdown/markdown/archive/3.3.1.tar.gz"
  sha256 "5edc04d4afa4b4a6859f50d73c5e64bb4a1b5f44debe26398ee0f1040b0635a6"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "227ab39f729b0a40dd97caf586a7e266a99d3f35336f72e4d58d4661503b2136" => :catalina
    sha256 "a228e7d1b8b1b7664c08c0fae396078ecc45b33e0eda18505bce9102360e1860" => :mojave
    sha256 "47cb77b2f55b21b8c6e82743620eef667dd19fa1ffa49046a0e7b35cda6a5ff4" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
