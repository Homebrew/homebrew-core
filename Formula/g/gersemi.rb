class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/86/ba/7bda45384ea5b2185611dfbf3a4766974b616108ee4c5f8d0f2d6fb35935/gersemi-0.27.2.tar.gz"
  sha256 "9faa43c82843400ee1f0a78b3329f173b82a1bf3297b18c6c1413f204b6a0493"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0338e3c19ca5dc75c7347db55afac3d63c7f09dd70f1eecba0f393af50ce4b6c"
    sha256 cellar: :any,                 arm64_sequoia: "3ab1452935c027a0bc763e585ff2862721ed757c168a8531caffe33dd0b236e0"
    sha256 cellar: :any,                 arm64_sonoma:  "fa63aef6283ff62e85b7ec93a61d510ca465e273d6c0b9cbd091e173dc8e7721"
    sha256 cellar: :any,                 sonoma:        "842d12ee8632638719557c7ef278d29dd3481f7c60b67653a20600e18d3e5bab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8238f72978f906ebf5c477f96bd61adfe33b6b1664b93a748e7f2ce69e9f6d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "276b3ea359ad4210e4e49c4bb0bb632a4e2b47104f73a5dac38997c6f7e7bfb1"
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
