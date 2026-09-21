class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/30/dd/406b5940cc7d7ab791385fb9cac1d101f41dbdc45989d3dcb4a6972f28fb/gersemi-0.29.1.tar.gz"
  sha256 "f40131536a42debab879448aa24c0bcac09ba792919bcaa605b11544b3b7f992"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8840440958fd0fa8257318de5719f9c19c3245eb69f8260400b22b4c68563ab9"
    sha256 cellar: :any, arm64_tahoe:       "f5e4e8becdb60f5568914e7565b4d880d85d3cebd81a91503e461c866101681d"
    sha256 cellar: :any, arm64_sequoia:     "b98e3001797e08018609b167e7cb8dbcc80b13c24bcb45025b92cba685701d4f"
    sha256 cellar: :any, arm64_linux:       "ca4d3ae8721a9ccf3defd8787018a506aa35d07a43bc90db4607aebfa9f1d14a"
    sha256 cellar: :any, x86_64_linux:      "45b16f699d670e495f97fd975cb07b32854071c3ab3c3c2f026ae4182f6ebd12"
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
