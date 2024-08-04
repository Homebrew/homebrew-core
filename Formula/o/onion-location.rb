class OnionLocation < Formula
  include Language::Python::Virtualenv

  desc "Discover advertised Onion-Location for given URLs"
  homepage "https://codeberg.org/Freso/python-onion-location"
  url "https://files.pythonhosted.org/packages/72/0d/e2656bdb8c66dc590da40622ca843f0513cd6f4b78bb1f9b6ed4592d283e/onion_location-0.1.0.tar.gz"
  sha256 "37dc14eab3a22b8948f8301542344144682108d1564289482827dc45106ee1d5"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Freso/python-onion-location.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40baaf460fd529c93198d622e3843854980b9b86c7d0b066fc35b82eb01e6285"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdd7688143306e60461c961c8d1c6255ccd9932291fb0b7ac8f01c373d3053ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e3750c53aadec6941900b442340d990a408386625ed668c996dfd099b9581a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a451e42f6b920fe7dc22533d2e5a10160ca75aa171b7ae34789bfd1719988607"
    sha256 cellar: :any_skip_relocation, ventura:        "14f7e65048460f0086c4e4af6afd614f99d65411151b2a4db9822b185e08e9c2"
    sha256 cellar: :any_skip_relocation, monterey:       "fb6d61d8ecc0b79396d2b55256a29c6a45950a00376279090649e6df7018a185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25dc68d8d70f089ebaff1f5c86e6f15787e4f96c9f7fcc9ad1482d09a6b90ac7"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "http://2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion/index.html",
      shell_output("#{bin}/onion-location https://www.torproject.org/")
  end
end
