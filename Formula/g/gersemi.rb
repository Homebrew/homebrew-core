class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/e3/9d/db3d44c0b8ee2cefe39a0546bc72d1927387b46c53b606ce7249f0c9d7b6/gersemi-0.22.2.tar.gz"
  sha256 "5a5fbe46962cafbf41b6fbff893d5d956a066639a7877c4f365e4d3ddfb1c226"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fb385d2f88ec12193485bc7dac60f2bdab453b06832bfae53bca416ae1b5c7a"
    sha256 cellar: :any,                 arm64_sequoia: "2d508bb441ee26b37eafc43d37ca3b942c21b074611483da2506bb03295dc868"
    sha256 cellar: :any,                 arm64_sonoma:  "c74613b23263dec3746c1bf121759621c882c9ae7f090639513e9d5ce9a28282"
    sha256 cellar: :any,                 arm64_ventura: "309b69e73f6565a3544611cf31ce5c62b6b135fc0d82c3186531af2f2ceee2af"
    sha256 cellar: :any,                 sonoma:        "5a1402ce7595319739d4fc4816d82953c39ab666e2d99a9ac92130ce6595b417"
    sha256 cellar: :any,                 ventura:       "957e1716c269736bf16238bb850359ca625d25744e8337848756a41f555c19c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "511a7afb4e1d262b4e167d626c06f5d55fc81c3263997ba196725c7c67097564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12a01d7220da9521b0848a1a012bac34f9a55abbb6bb5bf096bab7493fe570b4"
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
