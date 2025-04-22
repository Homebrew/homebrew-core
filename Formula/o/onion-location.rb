class OnionLocation < Formula
  include Language::Python::Virtualenv

  desc "Discover advertised Onion-Location for given URLs"
  homepage "https://codeberg.org/Freso/python-onion-location"
  url "https://files.pythonhosted.org/packages/72/0d/e2656bdb8c66dc590da40622ca843f0513cd6f4b78bb1f9b6ed4592d283e/onion_location-0.1.0.tar.gz"
  sha256 "37dc14eab3a22b8948f8301542344144682108d1564289482827dc45106ee1d5"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Freso/python-onion-location.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554a06ca904691fa000b6821292db2a79bfaafafcc4d454fe2ce0620e172b313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2617c96caf91e062cf0db6056b60950578d20a6df6fe812f4ee53c4309f40e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ea093e13440726264ce4bd5efdf417960122feaa76a42b4609fdd2c3304d809"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2afd83f62b2d82a043c85d6414616e302f98d47066d9bef7a5a02cd318e2254"
    sha256 cellar: :any_skip_relocation, ventura:       "0a15e033f4f7a39d15922df96da2dbbc45827f5aebdf2989f402819311b011f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7598772dd5bf3dc703622b0000e20d0f79e937e4f2865fc16e003c184057fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c3e568ec6369393e43bf7123fa7ef1e8fad4cfdd7a98b42f854f17fd8f07bca"
  end

  depends_on "python@3.13"

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
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "http://2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion/index.html",
      shell_output("#{bin}/onion-location https://www.torproject.org/")
  end
end
