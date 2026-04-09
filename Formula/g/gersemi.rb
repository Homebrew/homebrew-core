class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/cc/ea/d601c2caf8436ee8defc23297d8beb7999be8d34bb087802eb1c8202b9a5/gersemi-0.26.1.tar.gz"
  sha256 "10762fba8e9d867352b315407f9da85a8873eac3a46420e467a779fd8fe9b963"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0f3743f638ad6d348f3fbda16d34613a937bc306b9874c4d27622cafdc66eb3"
    sha256 cellar: :any,                 arm64_sequoia: "655563e0d45a4557e17395180284e19b1a099583232a7a96c9e511896abd4a2e"
    sha256 cellar: :any,                 arm64_sonoma:  "3a7f8f47b9bb8b5e83e3d6cc1ebb3c1e60cdbd1062543cf077167a8a598ff5ba"
    sha256 cellar: :any,                 sonoma:        "1817b84a41940dcddda9701131fa27e3ed8fdd0f57a671d7239eaeea4876717a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b035a27a4aa3b58e176b25a3670ebf1c8c8ba5f16ee55fb2e05fbe77babd160e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78bb1cdf573bab058a9c032e3401ffbe4bb19b038f7d137bb539712e180a1955"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/f4/4a/37928a560a345c6efb207452cf81d3c14f25a6d83df0fa5a00752c0c912b/ignore_python-0.3.3.tar.gz"
    sha256 "dc80ac80ace112da6d02f44681b6beb2ccecb68d6ac2b5e1b82d7f84347e1cf6"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
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
