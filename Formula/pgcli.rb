class Pgcli < Formula
  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/d2/71/59473625a4df68df7593b3fb86ac5a81bc5e29e2f9247acdfa4be08d3e43/pgcli-1.7.0.tar.gz"
  sha256 "fd8ef5011a354063dd53c95e9b39125c601f8bd406f973a74601f919aafb1181"
  revision 2

  bottle do
    sha256 "1574ae0f26253987feda503b74c0a4bdcb5e6bdfaba55c8cbe304555d8dabd3f" => :sierra
    sha256 "6aafb608eabec0b673849edde41555334e4570f32714f6b117f00dd491507d1f" => :el_capitan
    sha256 "0b4f03a74c1dbfbe5daf2d515315852a5a585e59ec84dd6092b232490b9537e5" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libpq"
  depends_on "openssl"

  resource "backports.csv" do
    url "https://files.pythonhosted.org/packages/6a/0b/2071ad285e87dd26f5c02147ba13abf7ec777ff20416a60eb15ea204ca76/backports.csv-1.0.5.tar.gz"
    sha256 "8c421385cbc6042ba90c68c871c5afc13672acaf91e1508546d6cda6725ebfc6"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/2b/7e/307131c2c3f3abef2d1e68b7088882c078da6ce5bb57cbe79bac12718c72/cli_helpers-0.2.1.tar.gz"
    sha256 "a868e69e780c1fd5091c83e784e8b18e2005cab921f1dfda4ffd376271ee85ac"
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
    url "https://files.pythonhosted.org/packages/bd/61/b35b4622813d6659653290bf6c001b22dc0c5d0b88c0948db47d15d1c42d/pgspecial-1.8.0.tar.gz"
    sha256 "89f524909e97554bb3eeceb186a834e86cb71e34afef3a95fe645049ead894b7"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/55/56/8c39509b614bda53e638b7500f12577d663ac1b868aef53426fc6a26c3f5/prompt_toolkit-1.0.14.tar.gz"
    sha256 "cc66413b1b4b17021675d9f2d15d57e640b06ddfd99bb724c73484126d22622f"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/f8/e9/5793369ce8a41bf5467623ded8d59a434dfef9c136351aca4e70c2657ba0/psycopg2-2.7.1.tar.gz"
    sha256 "86c9355f5374b008c8479bc00023b295c07d508f7c3b91dbd2e74f8925b1d9c6"
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
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/45/67/14bdaeff492e6d03a055fe80502bae10b679891c25a0dc59be2fe51002f8/sqlparse-0.2.3.tar.gz"
    sha256 "becd7cc7cebbdf311de8ceedfcf2bd2403297024418801947f8c953025beeff8"
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
