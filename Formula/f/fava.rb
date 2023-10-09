class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https://beancount.github.io/fava/"
  url "https://files.pythonhosted.org/packages/cf/3a/5b6a1ac427c46d599d545cd0cabc230a6dfd720a2b666a1590bcf545f3bd/fava-1.26.1.tar.gz"
  sha256 "a63e246900d76a18e137b6eeef1c53fd9ba809f3dd1b2a3cf7ce3cd92e609e51"
  license "MIT"
  head "https://github.com/beancount/fava.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "940ee3157d27b69424b239c6513ee9cfe34b1781070fdefb1cc89fb9e7d32468"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1d1934db702cee62a3787011beaa46f620d66895156c0c083169ca08fe65cc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1ddd68d385c7f296e5869902cd3a7611362f6ab5e90cfbabe9342c13d4dfb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "52fb65e69ec3dc88c4101e3a665025ede9392306418857e421e63af001d4e325"
    sha256 cellar: :any_skip_relocation, ventura:        "867f1dc39738d15fda4425563c63420f3b5779ac1d5fa4c60e7509aff6b24dee"
    sha256 cellar: :any_skip_relocation, monterey:       "1d394730a6f1573b3e66f314e8acf78ad6f0b3f00b109a5e0a285edbfebb81be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4855b7f60ce4384e863106bd215d9c3f0bba93ec5ad8a81d68fa759310607ba"
  end

  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "six"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/ba/42/54426ba5d7aeebde9f4aaba9884596eb2fe02b413ad77d62ef0b0422e205/Babel-2.12.1.tar.gz"
    sha256 "cc2d99999cd01d44420ae725a21c9e3711b3aadc7976d6147f622d8581963455"
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/77/51/2acc2741fa2937a3a1123fd00e6e76e6d6f27c46579ea53705c49bd221ec/beancount-2.3.5.tar.gz"
    sha256 "14e35625a2e9cbd43cae6178da08cb3f1224f6261e541ca6726df35d98e9c36a"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/e8/f9/a05287f3d5c54d20f51a235ace01f50620984bc7ca5ceee781dc645211c5/blinker-1.6.2.tar.gz"
    sha256 "4afd3de66ef3a9f8067559fb7a1cbe555c17dcbe15971b05d1b625c3e7abe213"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/08/7c/95c154177b16077de0fec1b821b0d8b3df2b59c5c7b3575a9c1bf52a437e/cheroot-10.0.0.tar.gz"
    sha256 "59c4a1877fef9969b3c3c080caaaf377e2780919437853fc0d32a9df40b311f0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/46/b7/4ace17e37abd9c21715dea5ee11774a25e404c486a7893fa18e764326ead/flask-2.3.3.tar.gz"
    sha256 "09c347a92aa7ff4a8e7f3206795f30d826654baf38b873d0744cd571ca609efc"
  end

  resource "flask-babel" do
    url "https://files.pythonhosted.org/packages/35/83/f31a4ff688168f9c8a73d80ebfc785dcd7703474a0802b25a78d54edd07c/flask_babel-3.1.0.tar.gz"
    sha256 "be015772c5d7f046f3b99c508dcf618636eb93d21b713b356db79f3e79f69f39"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/f3/b8/f727ada5b63aba53848e3791dd57be7481d5c9bf86978600ca9cca4ab03e/google-api-core-2.11.1.tar.gz"
    sha256 "25d29e05a0058ed5f19c61c0a78b1b53adea4d9364b464d014fbda941f6d1c9a"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/46/bb/698f5d2168dde75dab70aea53321d0cccf015b6ceb2083523c240863fa24/google-api-python-client-2.100.0.tar.gz"
    sha256 "eaed50efc2f8a4027dcca8fd0037f4b1b03b8093efc84ce3cb6c75bfc79a7e31"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/91/37/537df9b0823e3856f721f558615d99580c23de551f36e0b8618112b79f09/google-auth-2.23.0.tar.gz"
    sha256 "753a26312e6f1eaeec20bc6f2644a10926697da93446e1f8e24d6d32d45a922a"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/0f/7a/83c3a1f8419d66f91672ad7f2cea57d044f7f0b3c1740389a468ff3937ed/google-auth-httplib2-0.1.1.tar.gz"
    sha256 "c64bc555fdc6dd788ea62ecf7bccffcf497bf77244887a3f3d7a5a02f8e3fc29"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/08/78/aedf7f323cc6d4f2116556bd42c9ffab6021cf3f2fd9925ed4e71213dd1b/googleapis-common-protos-1.60.0.tar.gz"
    sha256 "e73ebb404098db405ba95d1e1ae0aa91c3e15a71da031a2eeb6b2e23e7bc3708"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/e6/f7/97322b08780ac7f783893991a1ed2a0a8b9c729d06350e2a1c6e7f8687cb/jaraco.functools-3.9.0.tar.gz"
    sha256 "8b137b0feacc17fef4bacee04c011c9e86f2341099c870a1d12d3be37b32a638"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/8e/b3/64c459af88ea8c2eeb020d0edf3e36c62176e988c47e412133c37c5da5e7/markdown2-2.4.10.tar.gz"
    sha256 "cdba126d90dc3aef6f4070ac342f974d63f415678959329cc7909f96cc235d72"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2d/73/3557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99/more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/79/30/98dc7297ce8c3f0182800d2879703f0196e76d6a28e53ecaafc3901f8118/protobuf-4.24.3.tar.gz"
    sha256 "12e9ad2ec079b833176d2921be2cb24281fa591f0b119b208b788adc48c2561d"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e5/d0/18209bb95db8ee693a9a04fe056ab0663c6d6b1baf67dd50819dd9cd4bd7/pytest-7.4.2.tar.gz"
    sha256 "a766259cfab564a2ad52cb1aae1b881a75c3eb7e34ca3779697c23ed47c47069"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/c0/5c/61e2afbe62bbe2e328d4d1f426f6e39052b73eddca23b5ba524026561250/simplejson-3.19.1.tar.gz"
    sha256 "6277f60848a7d8319d27d2be767a7546bc965535b28070e310b3a9af90604a4c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/ef/56/0acc9f560053478a4987fa35c95d904f04b6915f6b5c4d1c14dc8862ba0a/werkzeug-2.3.7.tar.gz"
    sha256 "2b8c0e447b4b9dbcc85dd97b6eeb4dcbaf6c8b6c3be0bd654e25553e0a2157d8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"fava", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # Find an available port
    port = free_port

    (testpath/"example.ledger").write <<~EOS
      2020-01-01 open Assets:Checking
      2020-01-01 open Equity:Opening-Balances
      2020-01-01 txn "Opening Balance"
        Assets:Checking 10.00 USD
        Equity:Opening-Balances
    EOS

    fork do
      exec bin/"fava", "--port=#{port}", testpath/"example.ledger"
    end

    # Wait for fava to start up
    sleep 5

    cmd = "curl -sIm1 -XGET http://localhost:#{port}/beancount/income_statement/"
    assert_match(/200 OK/m, shell_output(cmd))
  end
end
