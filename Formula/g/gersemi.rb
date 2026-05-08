class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/a9/92/772da571b13f6c4f2f6cc7c5ab952adc613e5befb9a994e7e9195b64c898/gersemi-0.27.4.tar.gz"
  sha256 "b005073af2e3777b2622949d093fbe0ddc2b376a4e78b4a14bc2468083c7ba25"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d49ad6ff20a926c8bee9013f6a6b639d6cf57e02350714b3695c3cc03d33bcd6"
    sha256 cellar: :any,                 arm64_sequoia: "cf1a2dc636c9a4f4a2d92ec551558dd7432ff5194ebbf2683e2173d90a9f4044"
    sha256 cellar: :any,                 arm64_sonoma:  "3485f8115e8c50aa90c455f71ac1f38ab6710b9e8cad92f9f71600157599ca7b"
    sha256 cellar: :any,                 sonoma:        "394ac1012c35744b1212cb02c1e8fb4910c40ae03edbf5da408c0b0b257a16af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "707254806e6807b0776bb547aed62ebc8e17022f45a82c2fee6924f0eddba1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb066b282713c887bd53e33fcedb76a21b76afd85d0ec68d59a88b2749bcce40"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/f4/4a/37928a560a345c6efb207452cf81d3c14f25a6d83df0fa5a00752c0c912b/ignore_python-0.3.3.tar.gz"
    sha256 "dc80ac80ace112da6d02f44681b6beb2ccecb68d6ac2b5e1b82d7f84347e1cf6"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

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
