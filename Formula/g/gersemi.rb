class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/1b/fe/b6ab9391da6f00466b821bc8731fce23304fc80560664d6b06c0f41e0507/gersemi-0.23.2.tar.gz"
  sha256 "20ff59fc9af53ef63557ab8fdad4b2429a6a8d84cf0c0d4e3960c29912b87b46"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff6c6c0ca1c369e654c013fc41595fae7042ea72e2c12cd14310673def2bcadc"
    sha256 cellar: :any,                 arm64_sequoia: "c8abe78589c6324abf44ecdf7cd2667cd3ef0fe540cac5227d534ffd8c74a0bf"
    sha256 cellar: :any,                 arm64_sonoma:  "6a0cca3c74c578876ac80c7f3aa342ad41d0cc52f3e63ef7dc4ecad14ac2f95b"
    sha256 cellar: :any,                 sonoma:        "6d6632aa2a257a4a051401e2d1106c4c0445e34d4e2869215a06ee57ac6351f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9115881cf7a1173092b462744a7fbeb25ccf8949858396c671234b826fd4f09b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b6a3779b804091acca60fa67138c40017884b49de067be376478c9d46f0d63"
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
