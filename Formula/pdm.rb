class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/87/4a/53ba82dc2b55b08251b0323eb18a4c80d7f359910c5ed3d7c76804f7aae5/pdm-2.2.1.tar.gz"
  sha256 "a861d47d57bc6ef9e99edb09abd620955a37b2835019b6a8918beea3b089a3b7"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79d06da2844e6ed941c20223cfe4c53f977498d3a85a2bdfafe5c8b8c63c40ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d32f82f157c38a1ffcd35010ef641149b1fbaf904553b09d3b669fe15786de4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fb5701061f2d5bf4fdea273c660e77fd1b329b6d200ee47aadc6cec97f036b7"
    sha256 cellar: :any_skip_relocation, monterey:       "b423e8c59b52e46b8ebe8dc7583a8e3dda79383e3a3c57e1e69f108d4a9c40c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4890967b60c46c3e97272c3ec6710fa72d9194f551f62b620601d11bd54aa0e1"
    sha256 cellar: :any_skip_relocation, catalina:       "dbc483de0a5698949ddde6a43902d950faf4bf1967c400ff8cba0f29892c8707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb0e0d97a96ce8a2e6e7215fd9212c4e3a070ad2054d20d32819d0dba6692a1"
  end

  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "six"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/2b/12/82786486cefb68685bb1c151730f510b0f4e5d621d77f245bc0daf9a6c64/blinker-1.5.tar.gz"
    sha256 "923e5e2f69c155f2cc42dafbbd70e16e3fde24d2d4aa2ab72fbe386238892462"
  end

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/06/80/1f8ba1ced5f29514d8621003b2b0fb404ed88996e963dbca7f519ecc82ca/CacheControl-0.12.12.tar.gz"
    sha256 "9c2e5208ea76ebd9921176569743ddf6d7f3bb4188dbf61806f0f8fc48ecad38"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "findpython" do
    url "https://files.pythonhosted.org/packages/28/96/ec16612c4384cfca9381239d06e9285ca41d749d4a5003df73e3a96255e7/findpython-0.2.2.tar.gz"
    sha256 "80557961c04cf1c8c4ba4ca3ac7cf76ec27fa92788a6af42cb701e3450c49430"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/74/b7/9187323cd732840f1cddd6a9f05961406636b50c799eef37c920b63110c0/installer-0.5.1.tar.gz"
    sha256 "f970995ec2bb815e2fdaf7977b26b2091e1e386f0f42eafd5ac811953dc5d445"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/2d/59/15ff8715a14fb26fec56a0d66f7a53d27e5d14a550fc12fefd446fc74684/pdm-pep517-1.0.5.tar.gz"
    sha256 "74ece9694c4ff5f903fba000ec43f075143872c41248daccecf7464f98ce680c"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/4d/19/e11fcc88288f68ae48e3aa9cf5a6fd092a88e629cb723465666c44d487a0/pep517-0.13.0.tar.gz"
    sha256 "ae69927c5c172be1add9203726d4b84cf3ebad1edcd5f71fcdc746e66e829f59"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/87/8d/ab7352188f605e3f663f34692b2ed7457da5985857e9e4c2335cd12fb3c9/python-dotenv-0.21.0.tar.gz"
    sha256 "b77d08274639e3d34145dfa6c7008e66df0f04b7be7a75fd0d5292c191d79045"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/0c/4c/07f01c6ac44f7784fa399137fbc8d0cdc1b5d35304e8c0f278ad82105b58/requests-toolbelt-0.10.1.tar.gz"
    sha256 "62e09f7ff5ccbda92772a29f394a49c3ad6cb181d568b1337626b2abb628a63d"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/bd/e6/fdf53ebbf08016dba98f2b047d4db95790157f0e2eed3b14bb5754271475/shellingham-1.5.0.tar.gz"
    sha256 "72fb7f5c63103ca2cb91b23dee0c71fe8ad6fbfd46418ef17dbe40db51592dad"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "unearth" do
    url "https://files.pythonhosted.org/packages/44/95/e53610248a8a590f2b5e716e173ca1b6b6f97734fa361069d316addac7ad/unearth-0.6.1.tar.gz"
    sha256 "4b7bfbd7d34a11673d80dfae7fabbf921c139aac78383fb0ca16a90d3b53a66e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b4/27/b71df0a723d879baa0af1ad897b2498ad78f284ae668b4420092e44c05fa/virtualenv-20.16.6.tar.gz"
    sha256 "530b850b523c6449406dfba859d6345e48ef19b8439606c5d74d7d3c9e14d76e"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/46/57/f39f082f448205ec06a771fe30eec77ed650c0c8e3f7d7f193e12efb4fd4/wheel-0.38.0.tar.gz"
    sha256 "d52844afee64cdd4bb28061ba6b5c06818b237fb490263e0dbea227080f7d2d7"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"pdm", "completion")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-pep517>=0.12.0"]
      build-backend = "pdm.pep517.api"

    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "dependencies = [\n    \"requests==2.24.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
