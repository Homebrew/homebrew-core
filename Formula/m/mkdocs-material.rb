class MkdocsMaterial < Formula
  include Language::Python::Virtualenv

  desc "Material Design theme for MkDocs"
  homepage "https://squidfunk.github.io/mkdocs-material/"
  url "https://files.pythonhosted.org/packages/9c/3b/111b84cd6ff28d9e955b5f799ef217a17bc1684ac346af333e6100e413cb/mkdocs_material-9.7.0.tar.gz"
  sha256 "602b359844e906ee402b7ed9640340cf8a474420d02d8891451733b6b02314ec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "956163d883c535f92084f64da8915759d0a140d11147d0930a4bda81a5be6eb1"
    sha256 cellar: :any,                 arm64_sequoia: "bf0f181acf0c3903ef703db318396800bf2605cd69e4495108f8f8dcb003fb66"
    sha256 cellar: :any,                 arm64_sonoma:  "4178dd3833b83e82a4faa3bbcf7353502d122460050bf7d6aa80a7314166af57"
    sha256 cellar: :any,                 sonoma:        "e90ab6379e7e543b63361f4598e0a985ae25664d2b993b811385784b1b04314c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ccae56059c0bc2ac6a1a588c0cfe9c83884a08063695450842ca63d9a44073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "973fafc9115622b6401a29ffde6f1b18760304bada6cc63a0cef2f60cf5011fb"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "mkdocs", because: "both install `mkdocs` binaries"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/6b/d52e42361e1aa00709585ecc30b3f9684b3ab62530771402248b1b1d6240/babel-2.17.0.tar.gz"
    sha256 "0c54cffb19f690cdcc52a3b50bcbf71e07a808d1c80d549f2459b9d2cf0afb9d"
  end

  resource "backrefs" do
    url "https://files.pythonhosted.org/packages/91/e6/5eac48095081c358926a0cd8821351d7a013168b05cad9530fa3bcae3071/backrefs-6.0.1.tar.gz"
    sha256 "54f8453c9ae38417a83c06d23745c634138c8da622d87a12cb3eef9ba66dd466"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4c/5b/b6ce21586237c77ce67d01dc5507039d444b630dd76611bbca2d8e5dcd91/certifi-2025.10.5.tar.gz"
    sha256 "47c09d31ccf2acf0be3f701ea53595ee7e0b8fa08801c6624be771df09ae7b43"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ghp-import" do
    url "https://files.pythonhosted.org/packages/d9/29/d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4/ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/7d/ab/7dd27d9d863b3376fcf23a5a13cb5d024aed1db46f963f1b5735ae43b3be/markdown-3.10.tar.gz"
    sha256 "37062d4f2aa4b2b6b32aefb80faa300f82cc790cb949a35b8caede34f2b68c0e"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "mkdocs" do
    url "https://files.pythonhosted.org/packages/bc/c6/bbd4f061bd16b378247f12953ffcb04786a618ce5e904b8c5a01a0309061/mkdocs-1.6.1.tar.gz"
    sha256 "7b432f01d928c084353ab39c57282f29f92136665bdd6abf7c1ec8d822ef86f2"
  end

  resource "mkdocs-get-deps" do
    url "https://files.pythonhosted.org/packages/98/f5/ed29cd50067784976f25ed0ed6fcd3c2ce9eb90650aa3b2796ddf7b6870b/mkdocs_get_deps-0.2.0.tar.gz"
    sha256 "162b3d129c7fad9b19abfdcb9c1458a651628e4b1dea628ac68790fb3061c60c"
  end

  resource "mkdocs-material-extensions" do
    url "https://files.pythonhosted.org/packages/79/9b/9b4c96d6593b2a541e1cb8b34899a6d021d208bb357042823d4d2cabdbe7/mkdocs_material_extensions-1.3.1.tar.gz"
    sha256 "10c9511cea88f568257f960358a467d12b970e1f7b2c0e5fb2bb48cab1928443"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paginate" do
    url "https://files.pythonhosted.org/packages/ec/46/68dde5b6bc00c1296ec6466ab27dddede6aec9af1b99090e1107091b3b84/paginate-0.5.7.tar.gz"
    sha256 "22bd083ab41e1a8b4f3690544afb2c60c25e5c9a63a30fa2f483f6c60c8e5945"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pymdown-extensions" do
    url "https://files.pythonhosted.org/packages/55/b3/6d2b3f149bc5413b0a29761c2c5832d8ce904a1d7f621e86616d96f505cc/pymdown_extensions-10.16.1.tar.gz"
    sha256 "aace82bcccba3efc03e25d584e6a22d27a8e17caa3f4dd9f207e49b787aa9a91"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "pyyaml-env-tag" do
    url "https://files.pythonhosted.org/packages/eb/2e/79c822141bfd05a853236b504869ebc6b70159afc570e1d5a20641782eaa/pyyaml_env_tag-1.1.tar.gz"
    sha256 "2eb38b75a2d21ee0475d6d97ec19c63287a7e140231e4214969d0eac923cd7ff"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/mkdocs"
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<~YAML
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: material
    YAML
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<~MARKDOWN
      # A heading

      And some deeply meaningful prose.
    MARKDOWN
    system bin/"mkdocs", "build", "--clean"
  end
end
