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
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "8faeb282de11f645e221dc739a28c1ba308ab14f26cd19da5378179eb040217e"
  end

  depends_on "python@3.13"

  resource "coverage" do
    url "https://files.pythonhosted.org/packages/38/df/d5e67851e83948def768d7fb1a0fd373665b20f56ff63ed220c6cd16cb11/coverage-5.5.tar.gz"
    sha256 "ebe78fe9a0e874362175b02371bdfbee64d8edc42a044253ddf4ee7d3c15212c"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # https://github.com/nicfit/eyeD3/pull/589
  patch do
    url "https://github.com/nicfit/eyeD3/commit/2632963eca6d84481d133fcac496434dad72e38f.patch?full_index=1"
    sha256 "6b4e7bf8b6b282b1eeab65c80c499934677357e1fa3ce21d4009bfc719b07969"
  end

  def install
    virtualenv_install_with_resources
    share.install Dir["docs/*"]
  end

  test do
    touch "temp.mp3"
    system bin/"eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end
