class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/e7/de/baafb537f824e0585561b70d7cf896a876e7c699887dec945a9c527e02b6/gersemi-0.22.3.tar.gz"
  sha256 "ae764e726ed2e9cefd696dc0f082fff77e2e51dd236c61739b18fee69fe406f4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ab2002b610a56f9e91af089d9271f3a7afde765863e53572ead9ebfefe08def"
    sha256 cellar: :any,                 arm64_sequoia: "4422d5427b8a26dd3ba442f323715ae6f4bea8e7241691c32dbec4960bc75331"
    sha256 cellar: :any,                 arm64_sonoma:  "fada96cb91103e695b7b1d45a3a47816bccecfa6095ee9cab924ed68433403f2"
    sha256 cellar: :any,                 sonoma:        "650a9184b40aa74c0c49204e0b4adf7e20d0fc33c20c069a706e3e50d37c72be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ba09e909ba3cbac9e54685c75fb434356947b62e728bdbb560567ff389c8e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aa64f1e2c67b80d64ee3732fb02725604b465f04ed6928fdcf52eb62048ac05"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/1d/37/a13baf0135f348af608c667633cbe5d13aa2c5c15a56ae9ad3e6cba45ae3/lark-1.3.0.tar.gz"
    sha256 "9a3839d0ca5e1faf7cfa3460e420e859b66bcbde05b634e73c369c8244c5fa48"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gersemi --version")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    # Return 0 when there's nothing to reformat.
    # Return 1 when some files would be reformatted.
    system bin/"gersemi", "--check", testpath/"CMakeLists.txt"

    system bin/"gersemi", testpath/"CMakeLists.txt"

    expected_content = <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    assert_equal expected_content, (testpath/"CMakeLists.txt").read
  end
end
