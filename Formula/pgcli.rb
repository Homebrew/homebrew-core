class Pgcli < Formula
  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "http://pgcli.com/"
  url "https://files.pythonhosted.org/packages/c3/24/91f4b4c6bce71c92187aa3919ef42028f4af3b4f1485769709d37237384a/pgcli-1.1.0.tar.gz"
  sha256 "d4a2491b0fad140d4fdf63928224f7bc1a84f6fda99a791b05ecca2752b44d5a"

  bottle do
    cellar :any
    sha256 "7502581f3125bc4938b09c10d33e5bdd12d85f31c9c3aab045e00323b27c15d8" => :sierra
    sha256 "5543710b707f44c8824872c38009b69d7390fdd7dccd491ac386a8bb45914b22" => :el_capitan
    sha256 "b01031b595cf6a1c4945e54b72dd6adffce4dafdb5d363796a4f8c3a646a0a3e" => :yosemite
    sha256 "df7edd6799ccda5fbdbb55c89fc91b31311902edf9a3607d684d2eebe71a2a4e" => :mavericks
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
    url "https://files.pythonhosted.org/packages/f8/07/c799a14af14719769a4b47414e3455e1458d401722d0d351aad64389e72b/pgspecial-1.5.0.tar.gz"
    sha256 "cd4c4a0655be80f15eadc116a576f16c7147338e27f3f2fe8cc3fa6519a77891"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/c0/d0/dcb9235c812b70f20d8d1ff110f9caa85daf4bf1ec2ac10516f51c07957e/prompt_toolkit-1.0.5.tar.gz"
    sha256 "b726807349e8158a70773cf6ac2a90f0c62849dd02a339aac910ba1cd882f313"
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
    url "https://files.pythonhosted.org/packages/9c/cc/3d8d34cfd0507dd3c278575e42baff2316a92513de0a87ac0ec9f32806c9/sqlparse-0.1.19.tar.gz"
    sha256 "d896be1a1c7f24bffe08d7a64e6f0176b260e281c5f3685afe7826f8bada4ee8"
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
