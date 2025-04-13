class EyeD3 < Formula
  include Language::Python::Virtualenv

  desc "Work with ID3 metadata in .mp3 files"
  homepage "https://eyed3.nicfit.net/"
  url "https://files.pythonhosted.org/packages/75/a5/263664ef1f1be58f72c8bc66ef128781af0a8110aeb591428d5c3a67b356/eyeD3-0.9.7.tar.gz"
  sha256 "93b18e9393376a45114f9409d7cca119fb6f4f9a37d4b697b500af48b4c5cf0f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c6a2d09381919f40cc7b2a78c63ff8b65b303091159632c27888b16e0c1e1bb"
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
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
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
    doc.install Dir["docs/*"]
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    assert_match "No ID3 v1.x/v2.x tag found", shell_output("#{bin}/eyeD3 test.mp3 2>&1")
    system bin/"eyeD3", "--artist", "HomebrewYo", "--track", "37", "test.mp3"
    assert_match "artist: HomebrewYo", shell_output("#{bin}/eyeD3 test.mp3 2>&1")
  end
end
