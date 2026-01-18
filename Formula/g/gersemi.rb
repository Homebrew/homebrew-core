class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/35/2a/5455504ca290394572fb3fc03baaf1ecd1186fb6b07ac28f33eb828af364/gersemi-0.25.1.tar.gz"
  sha256 "a119f5ff0c5133b25e72a5c39f7722535741cb311f66ae17bf1aaf1d1190751a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3bdb72da93c135297ed078e2c5b9cc51b146d4d0005a117eb5630b0b837ce66"
    sha256 cellar: :any,                 arm64_sequoia: "4bc01f2daefd8db0c1dccc288195e066056ca1b6db5bdf7cda402ead2412d8e5"
    sha256 cellar: :any,                 arm64_sonoma:  "578714bc000f4fd45439a7cbed39509216c6e67071ab9937319de18cd8ab6fb7"
    sha256 cellar: :any,                 sonoma:        "4b63d0c039fdfa2272392384b1d9aec1b54153f403aa9dbf1b3450655e45c260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7e5f2d441b86b961e4162925a4cf387bb7b2dc19b8287f10203fee0e7be6662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e537505a7b6109d564697696a44ce1214b2b7b4395f99624901cb2119a6aa48f"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/5a/c1/39cfd73def936e6c9c06ae6227b314c90f7a57d725cf1cd15e3f576906c6/ignore_python-0.3.1.tar.gz"
    sha256 "a9c691ca0f5002391fc10c7d8c29859d38594b4751a5eb43f95b5a9f7bda30bc"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
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
