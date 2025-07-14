class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/b3/ce/7a41407ba840543cfeb8226d00fc77585093bec5997b9dc31c68accf615c/gersemi-0.20.1.tar.gz"
  sha256 "acc33a7fba81e13a9feb1db5f57fe8ef65a3814a62b2ad5f4aec1e1df0e8d981"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c460c1aee91ab5057d4243185007d6be894ddf1fd79a2ed401389d153163453d"
    sha256 cellar: :any,                 arm64_sonoma:  "ff05b3209d64a55b830cd0538da11cc31e3355f130f4fea76f7e23043fd6d65d"
    sha256 cellar: :any,                 arm64_ventura: "c0c06124bc35f2e35f763e671cdd97f3b9ffaaa7b3a2a9658f729d7fb8723d3d"
    sha256 cellar: :any,                 sonoma:        "b62d99054334222929bcfab9edd3eaa22a4d3b42513f980d604069f05dfee9fa"
    sha256 cellar: :any,                 ventura:       "8d352bc296ce2da8cf72083a3cf9a823682357620f524d1b05f029dca41fff54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f9bce4b0c14d624fdf74c0da8e1d54656756f6020e7eab27343c5513d3a323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83397f78dab134230dd6415569badc069d3ed5640962da61bc87072a991a7f08"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
