class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/bd/e0/766c0c379b79674f6e8e3bd3c48ca4aa760ee118473fd49538e22fe38605/pgcli-2.0.0.tar.gz"
  sha256 "f173bc8f3841c146a51a5e56e714b6d1abcf8d8aa402fe8274561c668bb2ae20"

  bottle do
    cellar :any
    sha256 "27bdb25bfbb82fc04698e0fef6c9517de075e3388fac0a3925c7f2459df02665" => :mojave
    sha256 "9673c97693a3300ced995a0f1045c6374ddafbe3b0f2aea34278a3bb01d5b76a" => :high_sierra
    sha256 "86c45d6bc6aa7d878c87852ffc45efdfdfaf1a5bbe06911f2794460d52801215" => :sierra
    sha256 "5e92f1b75b24851236bd9ceee16a9477c69358100ed4415866bd631e352e0101" => :el_capitan
  end

  depends_on "libpq"
  depends_on "openssl"
  depends_on "python"

  resource "backports.csv" do
    url "https://files.pythonhosted.org/packages/c5/d2/6adc8e81e57a847fbe63b7967223aa13e340875a273be218ef15f162037d/backports.csv-1.0.6.tar.gz"
    sha256 "bed884eeb967c8d6f517dfcf672914324180f1e9ceeb0376fde2c4c32fd7008d"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/b1/18/7997f55d8128df26a3d12bfa1ebb2ed0d9834d9b073126f03f26695d7224/cli_helpers-1.1.0.tar.gz"
    sha256 "7c2038bba0c41f41acae0f6e660ff3b00d69f55d9d968f024952cace78111e12"
  end

  resource "Click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/96/11/55e1e2fb15032ade24a7e20cb8f90c8024bd75e11b806504fbf75bae6525/pgspecial-1.11.2.tar.gz"
    sha256 "60e81ed02c3a2d43a4eb70d5bbdeea7b0c5244580d3017edf89a6fd66e6503fb"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/d9/a5/4b2dd1a05403e34c3ba0d9c00f237c01967c0a4f59a427c9b241129cdfe4/prompt_toolkit-2.0.7.tar.gz"
    sha256 "fd17048d8335c1e6d5ee403c3569953ba3eb8555d710bfc548faf0712666ea39"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/c0/07/93573b97ed61b6fb907c8439bf58f09957564cf7c39612cef36c547e68c6/psycopg2-2.7.6.1.tar.gz"
    sha256 "27959abe64ca1fc6d8cd11a71a1f421d8287831a3262bd4cacd43bbf43cc3c82"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
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
    system bin/"pgcli", "--help"
  end
end
