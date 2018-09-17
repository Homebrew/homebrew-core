class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://mycli.net/"
  url "https://files.pythonhosted.org/packages/de/19/74c21a13074d13d955e2ad16943b0f12b0bf78845dc130f2d46f451b65cc/mycli-1.16.0.tar.gz"
  sha256 "29c65537b6616619b45956550fa76662caa6631eeee96e5cafd407909d8e9649"

  bottle do
    cellar :any
    sha256 "bf79d034424102875a80970389a4870cc79a34fd05ec6b71804f1eb1d523372a" => :mojave
    sha256 "0e595019db782a382f315a1c449334391b17630194193b45c61bfdd4e20efeb2" => :high_sierra
    sha256 "a1d590e59cd55c5539032bbb6e3682de3ac687c924418a57875fdac7cc7042c1" => :sierra
    sha256 "efb1798af243e65cc470d754439b5d82fde609081d5e77b40e0a29ea0d36b5d1" => :el_capitan
  end

  depends_on "openssl"
  depends_on "python@2"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "backports.csv" do
    url "https://files.pythonhosted.org/packages/6a/0b/2071ad285e87dd26f5c02147ba13abf7ec777ff20416a60eb15ea204ca76/backports.csv-1.0.5.tar.gz"
    sha256 "8c421385cbc6042ba90c68c871c5afc13672acaf91e1508546d6cda6725ebfc6"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/10/f7/3b302ff34045f25065091d40e074479d6893882faef135c96f181a57ed06/cffi-1.11.4.tar.gz"
    sha256 "df9083a992b17a28cd4251a3f5c879e0198bb26c9e808c4647e0a18739f1d11d"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/88/25/1fd3b2181b4e1fec360a1176a91ab715297b55db045e91af798c31c58aa3/cli_helpers-1.0.1.tar.gz"
    sha256 "55353117960700dfbe000a71cda0bad1ac865e3a9999f1fa81047fa9e1322d42"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/78/c5/7188f15a92413096c93053d5304718e1f6ba88b818357d05d19250ebff85/cryptography-2.1.4.tar.gz"
    sha256 "e4d967371c5b6b2e67855066471d844c5d52d210c36c28d49a8507b96e2c5291"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/f0/ba/860a4a3e283456d6b7e2ab39ce5cf11a3490ee1a363652ac50abf9f0f5df/ipaddress-1.0.19.tar.gz"
    sha256 "200d8686011d470b5e4de207d803445deee427455cd0cb7c982b68cf82524f81"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"
    sha256 "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "PyMySQL" do
    url "https://files.pythonhosted.org/packages/a8/b4/3544c8e6ed9b1c6a00e5b302e3d5a646e43a8a0ac5216f5ae8706688706e/PyMySQL-0.8.0.tar.gz"
    sha256 "32da4a66397077d42908e449688f2ec71c2b18892a6cd04f03ab2aa828a70f40"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/79/3c/2ad76ba49f9e3d88d2b58e135b7821d93741856d1fe49970171f73529303/sqlparse-0.2.4.tar.gz"
    sha256 "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/12/c2/11d6845db5edf1295bc08b2f488cf5937806586afe42936c3f34c097ebdc/tabulate-0.8.2.tar.gz"
    sha256 "e4ca13f26d0a6be2a2915428dc21e732f1e44dad7f76d7030b2ef1ec251cf7f2"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mycli", "--help"
  end
end
