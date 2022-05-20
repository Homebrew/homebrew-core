class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https://github.com/tfeldmann/organize"
  url "https://files.pythonhosted.org/packages/5e/2e/6afb23be979828a638a42ee767f25c3f703f5e85f4142095666d717a5e64/organize-tool-2.2.0.tar.gz"
  sha256 "f912ce6d71baaf163f8961da9dcc283dd0ad38a6186f6f6590c4efadcdf34cac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de7be059bb7dfe89aa68b4446789a92261c1890a4476a03305a61123c968c65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "591e0f8e053c3abe61feb0391ed78755979d388cb0f33b999945f2965b17850b"
    sha256 cellar: :any_skip_relocation, monterey:       "3a00038967a4cbc757410bf363c2b557b24c152dcc6ba463d22c73fc84b4987f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e41d6317a2970795a5b2e11aa80092f31c8b0b47f57c6438b0438af605798a4"
    sha256 cellar: :any_skip_relocation, catalina:       "8a040aacd711c87946829db89eff5c783e77940d12dfd219dc80d511e86104e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff9995c81e726a8262683446f851152d209f361cea0ee0987dd258953b9ad73c"
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
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
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
    url "https://files.pythonhosted.org/packages/89/e3/b36266381ae7a1310a653bb85f4f3658c462a69634fa9b2fef76252a50ed/Jinja2-3.1.1.tar.gz"
    sha256 "640bed4bb501cbd17194b3cace1dc2126f5b619cf068a726b98192a0fde74ae9"
  end

  resource "macos-tags" do
    url "https://files.pythonhosted.org/packages/d4/6e/e0b2ea37ef831a5c6b5aebbd14701d96d9dc061f04a867b05335a4bc099d/macos-tags-1.5.1.tar.gz"
    sha256 "f144c5bc05d01573966d8aca2483cb345b20b76a5b32e9967786e086a38712e7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
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
    url "https://files.pythonhosted.org/packages/38/2e/577f709fd6ef54cfa7cfa0ee177f98d36d5292b5231cc13e62b1548fca46/pyobjc-core-8.4.1.tar.gz"
    sha256 "df98669e957adb33566d9ef46773a5ac876a81afe8849c282d6a80448e35dd74"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/c9/f1/a6abd1b9af00e07593755818f52f8c370750b55bb9ea2e0dba262d559913/pyobjc-framework-Cocoa-8.4.1.tar.gz"
    sha256 "dc596bac0f5d424f67944e95b2d0d7c94a07c4166359d7b4a4d4ae4f8e112822"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
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
