class EyeD3 < Formula
  include Language::Python::Virtualenv

  desc "Work with ID3 metadata in .mp3 files"
  homepage "https://eyed3.nicfit.net/"
  url "https://eyed3.nicfit.net/releases/eyeD3-0.9.6.tar.gz"
  mirror "https://files.pythonhosted.org/packages/fb/f2/27b42a10b5668df27ce87aa22407e5115af7fce9b1d68f09a6d26c3874ec/eyeD3-0.9.6.tar.gz"
  sha256 "4b5064ec0fb3999294cca0020d4a27ffe4f29149e8292fdf7b2de9b9cabb7518"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/nicfit/eyeD3.git"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258101dfb0923a34f79feea463f224496917a3cf5bb2af0f5942df371044ac76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4613276d6a11d859910c4fc261acd46ed8c79f6fb39e1174fc9a0e3aa9a425f"
    sha256 cellar: :any_skip_relocation, monterey:       "878a0964d4e7f5fcbb71268afd12fc0fcca3bb0afb59f58b19e11efc95f76cf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fabd715d3a65c1227ba6f6f0f5f5ef6e4f30311fdb6a81c6ee64f29ab06b6315"
    sha256 cellar: :any_skip_relocation, catalina:       "fac417d9f81abb4a7f9a7c422e166eecafc1d7eedfeb0db93e47d59d9e1894b7"
    sha256 cellar: :any_skip_relocation, mojave:         "9a2595374e19a747a5c5e04bd25cd95d80cf99e3a78c9259fe9b4cd9414f9afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a85e5aba1fe2b28c9b7587e06cbea8b65585b0d5eb958a22fb760948092b0826"
  end

  depends_on "python@3.10"

  # Looking for documentation? Please submit a PR to build some!
  # See https://github.com/Homebrew/homebrew/issues/32770 for previous attempt.

  resource "coverage" do
    url "https://files.pythonhosted.org/packages/38/df/d5e67851e83948def768d7fb1a0fd373665b20f56ff63ed220c6cd16cb11/coverage-5.5.tar.gz"
    sha256 "ebe78fe9a0e874362175b02371bdfbee64d8edc42a044253ddf4ee7d3c15212c"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/89/4c/20819cc9250a657606c3d0f8d3c1d6e68cafab90dc5ec84ba54f80c86e0f/filetype-1.0.10.tar.gz"
    sha256 "323a13500731b6c65a253bc3930bbce9a56dfba71e90b60ffd968ab69d9ae937"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "temp.mp3"
    system "#{bin}/eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end
