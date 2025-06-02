class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/a2/45/52cef3aaf43d30a72fb939975cb96d911a742e0bd840c73eb37b208eead6/gersemi-0.19.3.tar.gz"
  sha256 "4e0c0d0b3655e3bf285392b9abf42d101d5bb0df079e0bfd56e7a7022872f7a9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a95ee3dcb7eac4412ca443eebc8315916fa7db054422312cd6000be3977c6b3"
    sha256 cellar: :any,                 arm64_sonoma:  "d157ef2d80b91cab433e2ceae39cdcfa734894dc246531db42a998c079bcc696"
    sha256 cellar: :any,                 arm64_ventura: "20fe5450643f6977ea5f5934e7dcccfccaeb52159c47afedb61e2d96a1cfd801"
    sha256 cellar: :any,                 sonoma:        "62f90922f416f44531ab0372cbd98479dab0e7d61df691e6424f38c909d9449a"
    sha256 cellar: :any,                 ventura:       "24c2f6fe2a5d6f3ece8a3acfc9188fe00237093f93b2846fcf00d5c2c116e38f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc4295b14f16be210309ee6a6e5f34692a0dab55c1c2c826380eb93c5d8e0e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa4d0e84282e9343ecadce6d4061aec2aa25e12efaa35fe04be3fe508b76dd8"
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
