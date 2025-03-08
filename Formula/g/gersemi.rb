class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/28/fa/65880ccdaf9711da590b8f1906aaf279788d51ac2e117840cd4207fbd742/gersemi-0.19.2.tar.gz"
  sha256 "bc31021b7f7a6d30360e6600ed1c6621a02c627a7b5d8f237cbcc8adcc7b1201"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90d259be0309a3fca14d476f3d24a2401394eefc4966d8db7dae4748bcf43dc7"
    sha256 cellar: :any,                 arm64_sonoma:  "38b492705da575b3b0785e48dd1e887eb53acaec827abf4be9534150a2219f15"
    sha256 cellar: :any,                 arm64_ventura: "891f6adfc231a1628ccfdb681f979e97faa186fde0e853b92ea06ed14462128d"
    sha256 cellar: :any,                 sonoma:        "e472584d092eae19c3f4372e8af7958d2efbc75e60245c39e12e619b6899bf38"
    sha256 cellar: :any,                 ventura:       "f1ff3ac0e4a54d1c7c26e9542cc3edc74c65077daa61ec243aa8a2b71aff751c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74f49f3fd8be09dacea1724fc86d55e96dfbccb8caa5dfd09d8e1d6edc1725fd"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
