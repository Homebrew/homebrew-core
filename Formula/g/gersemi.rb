class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/42/a9/fe83ed525ef8666a08e681f528b7567f2ae90bfad94cb06aa601577163d4/gersemi-0.26.0.tar.gz"
  sha256 "20853edb20a1d1c77057df8787eb4e17b9d1eb6facac13c47826924ff741fc73"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b88f81997fcaa33113302a555bbe0612d5da1d3d29809256f29a17d52f18d646"
    sha256 cellar: :any,                 arm64_sequoia: "07d0ed4a3b990e298396d2ec55bb349e89f5a9b25613c645ff8b39c25ff7c868"
    sha256 cellar: :any,                 arm64_sonoma:  "df3d13dcd56d3a0319d499cb4d5b3af401f9bcd434f0fdf5775b44ed313e4800"
    sha256 cellar: :any,                 sonoma:        "61af484b8e69ef59706167487e2372de164688b9dfd8b6de0b0ffbcec393dd48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1326fba218b208705f43265d9f859e8b3416cbaeddd6c96310b8fcab57b4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5acf1dc13c89822a49571c3b83d4bfdbb6c455db124de3e4ed9348cf11b78944"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/86/67/b4c74e93ebacaea2743f98e3195b02a2a9a9be74540b0a75cf8c6fdbac24/ignore_python-0.3.2.tar.gz"
    sha256 "264f17faa6c41f134511f400fae8401b2fee666f1c4e2827a3e02724ea294f8d"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d6/f3/1632085bda21cae242998e27f63d3a2c02cdcdb36cade334fa689f210903/platformdirs-4.9.0.tar.gz"
    sha256 "d8c98e89c427a101947441c7e77b4cd1c8ea717de6f3885e2aa9c73fce276207"
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
