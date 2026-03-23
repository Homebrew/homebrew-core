class OnionLocation < Formula
  include Language::Python::Virtualenv

  desc "Discover advertised Onion-Location for given URLs"
  homepage "https://codeberg.org/Freso/python-onion-location"
  url "https://files.pythonhosted.org/packages/72/0d/e2656bdb8c66dc590da40622ca843f0513cd6f4b78bb1f9b6ed4592d283e/onion_location-0.1.0.tar.gz"
  sha256 "37dc14eab3a22b8948f8301542344144682108d1564289482827dc45106ee1d5"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://codeberg.org/Freso/python-onion-location.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baa4ff2b02318710c4850c12d8edb6ab4bcc5af830b444c986a80868c5d528bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b71f3837e7e808014ee217baf60334de606a89578501704f5ef867f17a005277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9b7fdcf9c7d60d720575abaaae39b8957d798eee94dc1211004eb0303bc8da8"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb545649597b97ecd542a47aefbe7bad5fe08b6a553d80e47c53b1f826cefc3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad645508d83434779999108a74dae0912214966df64a4ac6744b53dc5b369bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ccd7b906a0e2d403e7c2670d2170e854a93f3935de3629c3ae4a4a7ada7e1b"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "http://2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion/index.html",
      shell_output("#{bin}/onion-location https://www.torproject.org/")
  end
end
