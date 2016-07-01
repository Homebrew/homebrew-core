class Pgcli < Formula
  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "http://pgcli.com/"
  url "https://pypi.python.org/packages/86/93/40c017988649b596a9237e4ef0833e05ed99d6e531d8732058d1795682ee/pgcli-1.0.0.tar.gz"
  sha256 "2ed5d5b46b0e2bfe09e4054449e2bf9c4ed964680b08314cd4cc3bf66eec5d0b"

  bottle do
    cellar :any
    sha256 "fe28fe0900829ca61a04d87478ffab9357a6e8027b31e5c2e8aa95c62b2e26b9" => :el_capitan
    sha256 "dae96de8155a808adc721833288095ff0f6b9d5340f5795f55a83f2db9610fc4" => :yosemite
    sha256 "6e47e357b20b29f4614cb4d1b0b6bd1a56d9b292dedca81af3e2c78c572b3f24" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on :postgresql

  resource "humanize" do
    url "https://pypi.python.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "sqlparse" do
    url "https://pypi.python.org/packages/9c/cc/3d8d34cfd0507dd3c278575e42baff2316a92513de0a87ac0ec9f32806c9/sqlparse-0.1.19.tar.gz"
    sha256 "d896be1a1c7f24bffe08d7a64e6f0176b260e281c5f3685afe7826f8bada4ee8"
  end

  resource "setproctitle" do
    url "https://pypi.python.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  resource "psycopg2" do
    url "https://pypi.python.org/packages/86/fd/cc8315be63a41fe000cce20482a917e874cdc1151e62cb0141f5e55f711e/psycopg2-2.6.1.tar.gz"
    sha256 "6acf9abbbe757ef75dc2ecd9d91ba749547941abaffbe69ff2086a9e37d4904c"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/c2/d1/7689293086a8d5320025080cde0e3155b94ae0a7496fb89a3fbaa92c354a/wcwidth-0.1.6.tar.gz"
    sha256 "dcb3ec4771066cc15cf6aab5d5c4a499a5f01c677ff5aeb46cf20500dccd920b"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "click" do
    url "https://pypi.python.org/packages/b7/34/a496632c4fb6c1ee76efedf77bb8d28b29363d839953d95095b12defe791/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/8d/de/412f23919929c01e6b55183e124623f705e4b91796d3d2dce2cb53d595ad/prompt_toolkit-1.0.3.tar.gz"
    sha256 "805e026f0cbad27467e93f9dd3e3777718d401a62788c1e84ca038e967ad8ba2"
  end

  resource "pgspecial" do
    url "https://pypi.python.org/packages/f8/07/c799a14af14719769a4b47414e3455e1458d401722d0d351aad64389e72b/pgspecial-1.5.0.tar.gz"
    sha256 "cd4c4a0655be80f15eadc116a576f16c7147338e27f3f2fe8cc3fa6519a77891"
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
