class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/c3/4d/329ed279ec0588d2ed8ba6406a5efc109a74ae160055be4055ded934e274/autopep8-2.3.0.tar.gz"
  sha256 "5cfe45eb3bef8662f6a3c7e28b7c0310c7310d340074b7f0f28f9810b44b7ef4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d16435999ff18191dc7bf285f667df379cfc1536a2edca4fccc5688d8964e24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d16435999ff18191dc7bf285f667df379cfc1536a2edca4fccc5688d8964e24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d16435999ff18191dc7bf285f667df379cfc1536a2edca4fccc5688d8964e24"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d16435999ff18191dc7bf285f667df379cfc1536a2edca4fccc5688d8964e24"
    sha256 cellar: :any_skip_relocation, ventura:        "9d16435999ff18191dc7bf285f667df379cfc1536a2edca4fccc5688d8964e24"
    sha256 cellar: :any_skip_relocation, monterey:       "9d16435999ff18191dc7bf285f667df379cfc1536a2edca4fccc5688d8964e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e71fc8ff6d4fe227bcb32852837a4184797d85a16f53114759bab3fbc2dd9197"
  end

  depends_on "python@3.12"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/10/56/52d8283e1a1c85695291040192776931782831e21117c84311cbdd63f70c/pycodestyle-2.12.0.tar.gz"
    sha256 "442f950141b4f43df752dd303511ffded3a04c2b6fb7f65980574f0c31e6e79c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
