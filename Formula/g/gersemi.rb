class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/96/3d/babcff7d305561ebe96124298dbb7e3acaaa21f04a6490a8f0987130233e/gersemi-0.28.0.tar.gz"
  sha256 "984b488fd7b4c6a77fb41e4291ca63b08fc2dfe46a722b6309e23b4fee5df7e0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2389f2894544ec62f211109773c5a5a3643b261500b55c125f9f4572495eda06"
    sha256 cellar: :any, arm64_sequoia: "b955f7afe598da5b00caf9337298c5fa1407e6d9ee30e074a136d756be7524ed"
    sha256 cellar: :any, arm64_sonoma:  "f7394d7aa3b9ef1e5a5cc868ac7b784e40420ce22712c1dcb4981250fec57e84"
    sha256 cellar: :any, sonoma:        "46e42f2f1957afa2dabfd0d770d1995caa048e2d0c9b75a0c34225d9b42ac610"
    sha256 cellar: :any, arm64_linux:   "3684d103d292c75bed2bc8b3b15a03cf4a96284e47ce228703530ff705606635"
    sha256 cellar: :any, x86_64_linux:  "4d73a742db89cb75a7d4cdb7b069bb0344851d2550146d74df72c666d5ab6738"
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
