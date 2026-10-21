class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/65/6a/278112b2d82169bfe6bd2bac025deb917d7c83f890d71509c988fedd9a01/gersemi-0.29.2.tar.gz"
  sha256 "3acab643bec6c8174fb90ece56d76a8381847f77873a1a6ae3211f5b40472c25"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e2abbfdc83a8a95b02e9f874b6c23bbe7821703758408086176ebf9a414c5d60"
    sha256 cellar: :any, arm64_tahoe:       "a5b3b993074eaadd2d9f8298d2fb5d561b2fe3f99cf3ffa4c17278cbec080b02"
    sha256 cellar: :any, arm64_sequoia:     "fe4a48e58a4c5221bd390ca17f4be4df85a6b899e92eef51c516a89e82b9b1ad"
    sha256 cellar: :any, arm64_linux:       "3117b7c13ea6f3ada303ddfa0d21820398210b97b1fdf37ebc436a3762791463"
    sha256 cellar: :any, x86_64_linux:      "ebae32e9f45d3018bae350324b9fefdd0612a3c5124c94734978e55353689934"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.15"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    ENV["CARGO_VERSION"] = Formula["rust"].version.to_s
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
