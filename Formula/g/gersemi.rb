class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/6a/01/2f8eecf33d9152926829ff405626ac10c9f5b7f7f8ab5bee80c21a0390e3/gersemi-0.23.1.tar.gz"
  sha256 "75f56665ce156cb5a23c52b757ce20ddb579872e0dd78ce9855d6dc39a78053a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fdbd4a8db8ac847e7de50f25b9ae768fb4766752c978a936b96060c4099469e"
    sha256 cellar: :any,                 arm64_sequoia: "279d3a68be81f88b0d1a6b8213562a66f6b8ab347a0dac5aafe7b0efc66b35a1"
    sha256 cellar: :any,                 arm64_sonoma:  "373561b4da8d7be645e9f186131ba9c087cb6cca2ff964a414495ee796ce1afc"
    sha256 cellar: :any,                 sonoma:        "78249707b3d26d70bb27b63f00eda9626a65a3abbef8185dd18f17d02bb5fbc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e859460730d7b2afea1e52c2e182e1fb5a69d05643d89833440ef1ff08607277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41bae9711b501aa8e1244f8c057c318dc2e144feda98fda4f4cef398287dcb85"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
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
