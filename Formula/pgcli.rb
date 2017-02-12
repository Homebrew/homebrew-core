class Pgcli < Formula
  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "http://pgcli.com/"
  url "https://files.pythonhosted.org/packages/75/68/0aabfa3bdfa6858247712526c8da13ea2fcd86af3d84cf16d7e937f7f971/pgcli-1.3.1.tar.gz"
  sha256 "49fcfeb60ca0793f060c7c9dcee34c9dc52486092f96853b882de7f7e75c9209"
  revision 1

  bottle do
    cellar :any
    sha256 "d65103250799cf8319b7ea4f48a5224b48f280300c144356623ebc2082861e6f" => :sierra
    sha256 "384dd40c074fada220c56dcf3f95d68b45b2ac381e47822eb759ab05afc1ae60" => :el_capitan
    sha256 "91911c3ca0679552351bc142cb85a0f4726e939c128c676dd07cd716da1565a2" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on :postgresql

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
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
    url "https://files.pythonhosted.org/packages/d1/09/7b278f8d5334b3875870d96a9d71b4d9aa64e398eeb3cfe60a54eea35865/pgspecial-1.6.0.tar.gz"
    sha256 "55685887bf218e055cb6a17870d83a29e27650951a2362d2710651f62e553426"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/7f/72/845e3e5678ebe016fe2cff2ffaf91fc9615b9b1a630134f34cf394aa3927/prompt_toolkit-1.0.8.tar.gz"
    sha256 "b686ff216fc016dcbdf9ddf18d0ded480457213886ed4cda9fbc21002d18be54"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/7b/a8/dc2d50a6f37c157459cd18bab381c8e6134b9381b50fbe969997b2ae7dbc/psycopg2-2.6.2.tar.gz"
    sha256 "70490e12ed9c5c818ecd85d185d363335cc8a8cbf7212e3c185431c79ff8c05c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
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
    url "https://files.pythonhosted.org/packages/55/ce/3944e990b03f80f36f0050b407ad46cde192a210d473f0d705b554bddd1d/sqlparse-0.2.2.tar.gz"
    sha256 "d446296b2c26f9466860dd85fa32480bec523ab96bda8879262c38e8e8fbba21"
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

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"pgcli", "--help"
  end
end
