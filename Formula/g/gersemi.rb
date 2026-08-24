class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/24/e8/089e6b68a3640ca8e16ec99280a4f1b3504865d04f00179b0a1b58d64b43/gersemi-0.28.1.tar.gz"
  sha256 "a05086e4b975fd784d562b8053ddd96340cdc64ca092cc63a77c3e6be5a2c43f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9f6ed0fbd6e98d100079f24715f3985cdd660f976a2c472f7de8e394a21f6833"
    sha256 cellar: :any, arm64_sequoia: "61d8d2c16fa995becf416e58abc49f05e65bf9786aa17e1a09a122d334cfe009"
    sha256 cellar: :any, arm64_sonoma:  "5c548f75e248cd9dba5910cd3ba7b27fd5a1a027a2094d2aa1242f87b7f403b3"
    sha256 cellar: :any, sonoma:        "4ec361fb3fc1c0d74de401307a64cbd51cdbc92acfa48da68f533a09254adf3d"
    sha256 cellar: :any, arm64_linux:   "19de9cd79a606ddf7ed17629839f04b4ebd4594a99b77a7228e274a0aebbdccc"
    sha256 cellar: :any, x86_64_linux:  "b4f165b6440befe7195eeab580636cc152cf4d190df9fc65839a4f808352a472"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

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
