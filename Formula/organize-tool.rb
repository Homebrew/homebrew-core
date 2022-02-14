class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https://github.com/tfeldmann/organize"
  url "https://files.pythonhosted.org/packages/93/2a/c9463d10ace823cb26311774ba61ba31740524dce058c118746357303904/organize-tool-2.1.2.tar.gz"
  sha256 "dd4c894d1c864b68995fbc28c136b986c0a795facfa2e89d1488dd8bac4b0457"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d610ebc26a35b601d7c77b21be43da7cc851f1f180412936112de73c0f53fd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16baaa42fabdcef2ef1b0e293f8ab2893d227bd7f5d53d894f5b5c3208178338"
    sha256 cellar: :any_skip_relocation, monterey:       "dd34d46c7736aa76093e5ceba3d374576206f1c6a00dc61eab604fc909bc3693"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac6b30ffcf054e129cfbe87b051168f8fbf2d8c8140c3a3302b33720e5c0891e"
    sha256 cellar: :any_skip_relocation, catalina:       "118a65fe5819d765caa2843e22291308bb35f18b0a719905a70ef7c1de557d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db45c0bbca601bb4b277259efc6fe0f44adaeced08a77401238cc2b1a25655e6"
  end

  depends_on "freetype"
  depends_on "openjpeg"
  depends_on "python@3.10"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "ExifRead" do
    url "https://files.pythonhosted.org/packages/5f/a6/e5bdca841e5cc1a0eb7b9bf64854a4bf4e19e6de1a14092f93b8c907e87a/ExifRead-2.3.2.tar.gz"
    sha256 "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766"
  end

  resource "fs" do
    url "https://files.pythonhosted.org/packages/7f/51/f2d13086c997f7c7c39b9e11817dc122ca6cf19f7b67a337c372ecae3f7c/fs-2.4.15.tar.gz"
    sha256 "b09d02c311f4add1e6e2b75724c450eafcfeecc917579224ca8ad21dacd0a182"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "macos-tags" do
    url "https://files.pythonhosted.org/packages/d4/6e/e0b2ea37ef831a5c6b5aebbd14701d96d9dc061f04a867b05335a4bc099d/macos-tags-1.5.1.tar.gz"
    sha256 "f144c5bc05d01573966d8aca2483cb345b20b76a5b32e9967786e086a38712e7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "mdfind-wrapper" do
    url "https://files.pythonhosted.org/packages/0e/74/148968c2665c0f2db1fbd470fbb454b1f808ea5d4cb8d75bc99f451d0ece/mdfind-wrapper-0.1.5.tar.gz"
    sha256 "c0dbd5bc99c6d1fb4678bfa1841a3380ccac61e9b43a26a8d658aa9cafe27441"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/59/b0/abf64f846a4c3c115b546b4fa68b734bb750eed87fd5af6f73a5489eecd6/pyobjc-core-8.2.tar.gz"
    sha256 "6afb8ee1dd0647cbfaaf99906eca3b43ce045b27e3d4510462d04e7e5361c89b"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/d2/75/0e01d51f4b4cc5c1bf2509fe622f5d3eac09626bc5ebe3c7ad34fe5cfdff/pyobjc-framework-Cocoa-8.2.tar.gz"
    sha256 "f0901998e2f18415ef6d1f8a12b083f69fc93bd56b3e88040002e3c09bd8c304"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/72/de/b3a53cf1dfdbdc124e8110a60d6c6da8e39d4610c82491fc862383960552/rich-11.2.0.tar.gz"
    sha256 "1a6266a5738115017bb64a66c59c717e7aa047b3ae49a011ede4abdeffc6536e"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/49/2c/d990b8d5a7378dde856f5a82e36ed9d6061b5f2d00f39dc4317acd9538b4/Send2Trash-1.8.0.tar.gz"
    sha256 "d2c24762fd3759860a0aff155e45871447ea58d2be6bdd39b5c8f966a0c99c2d"
  end

  resource "simplematch" do
    url "https://files.pythonhosted.org/packages/1a/3d/4504e218fe50c988c8229fe4bfd5633ed43e1fa79de7147c5ddfec270fae/simplematch-1.3.tar.gz"
    sha256 "ed1d17d842799ee2222de1ea5f7fc3b4b1317464852214dc7dd197c1332a9f3c"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/91/ac/5898d1811abc88c3710317243168feff61ce12be220b9c92ee045ecd66c4/xattr-0.9.9.tar.gz"
    sha256 "09cb7e1efb3aa1b4991d6be4eb25b73dc518b4fe894f0915f5b0dcede972f346"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    dependencies = resources.map(&:name).to_set
    if OS.linux?
      # `macos-tags` and its dependencies are only needed on macOS
      # TODO: Currently requires manual check to confirm PyPI dependency tree
      dependencies -= %w[macos-tags mdfind-wrapper xattr cffi pycparser]
      # Same for `pyobjc-framework-cocoa` and its dependencies
      dependencies -= %w[pyobjc-framework-Cocoa pyobjc-core]
    end
    dependencies.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"config.yaml").write <<~EOS
      rules:
        - locations: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    EOS

    touch testpath/"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}/organize sim --config-file=#{testpath}/config.yaml")
    system bin/"organize", "run", "--config-file=#{testpath}/config.yaml"
    refute_predicate testpath/"homebrew.txt", :exist?
  end
end
