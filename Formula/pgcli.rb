class Pgcli < Formula
  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/91/84/e3be2851c87a9550cc747ba85ade36d1b51bb9a747ac93025a01a25baa41/pgcli-1.8.2.tar.gz"
  sha256 "79b32cb0a44e03fc6c26d43080459d48d39d6d81391eb09062a82c940b61441c"

  bottle do
    cellar :any
    sha256 "ca4796a22b658f8e7a46797eb937d452b25f906ef4774c5fc785d0e13d6fc9b0" => :high_sierra
    sha256 "0be32aadcb4d4de65908ddaf071f276ced76de0dd612a17bd994b530bffa8ad8" => :sierra
    sha256 "2f9dd812d687aaf7b4250f1ccefd834b61046fa84209b7876abb92e1ab534057" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libpq"
  depends_on "openssl"

  resource "backports.csv" do
    url "https://files.pythonhosted.org/packages/6a/0b/2071ad285e87dd26f5c02147ba13abf7ec777ff20416a60eb15ea204ca76/backports.csv-1.0.5.tar.gz"
    sha256 "8c421385cbc6042ba90c68c871c5afc13672acaf91e1508546d6cda6725ebfc6"
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

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/73/30/2f6ca8c9c7199a04d7c0d79405e1a6ec6841074b1b002307c00d8738c41b/pgspecial-1.9.0.tar.gz"
    sha256 "493cbbb1dfd2610c8be948d31355e3919f3adf24689ee439d42f4c1685406ac8"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"
    sha256 "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/dd/47/000b405d73ca22980684fd7bd3318690cc03cfa3b2ae1c5b7fff8050b28a/psycopg2-2.7.3.2.tar.gz"
    sha256 "5c3213be557d0468f9df8fe2487eaf2990d9799202c5ff5cb8d394d09fad9b2a"
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
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # backports is a namespace package
    touch libexec/"vendor/lib/python2.7/site-packages/backports/__init__.py"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"pgcli", "--help"
  end
end
