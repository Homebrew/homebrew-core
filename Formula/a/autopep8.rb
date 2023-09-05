class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/e0/8a/9be661f5400867a09706e29f5ab99a59987fd3a4c337757365e7491fa90b/autopep8-2.0.4.tar.gz"
  sha256 "2913064abd97b3419d1cc83ea71f042cb821f87e45b9c88cad5ad3c4ea87fe0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36de75d0e997f7c1bc641887d3b5afaa431f4627d0f81e1063d50cb9f8b0611c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e5360983afa86681a67f5e990bfc4f5e64a2219765787b758f21382650f142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6998c1c00f9514ec14eb56fc4eeafdd2e7bd653a8580467759cfddd901362294"
    sha256 cellar: :any_skip_relocation, ventura:        "015da1d24ec154c9dbe483bee4eb6dd11b46e5753a93703aca90a2a1f55b04a1"
    sha256 cellar: :any_skip_relocation, monterey:       "7ada12c470062e74388d795f4c5dbdb16aba23244cbaaacb193c7f2bf6b45873"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f43c56095df935ee2d399412d2b06642f32bd973bf24918e200d9f8d8fb4b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6390f91af41962e963c4b1b4d9b72ffe68302fe5eebeefd4ba40eda03760711d"
  end

  depends_on "python@3.11"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/c1/2d/022c78a6b3f591205e52b4d25c93b7329280f752b36ba2fc1377cbf016cd/pycodestyle-2.11.0.tar.gz"
    sha256 "259bcc17857d8a8b3b4a2327324b79e5f020a13c16074670f9c8c8f872ea76d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
