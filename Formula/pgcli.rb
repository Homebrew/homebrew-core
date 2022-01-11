class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/45/ae/4e11eaba77b0a6e662bbd18e39ecd66b18d95bb45ed1cf862fb7381b2dea/pgcli-3.3.0.tar.gz"
  sha256 "3d0ed40df691d60254ccb4d5654a52c1c6373f77d2b3cf6a90aea6ee99fea439"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "63da3541ba61725e63a3dd3dd38d75627d792a9604fb90a6c6be9ac2b9521672"
    sha256 cellar: :any,                 arm64_big_sur:  "a84512d680d97f3817bca3d15c1aa6f0826cfafc282938d63eeef91df1ac9bd8"
    sha256 cellar: :any,                 monterey:       "c487c021f1a8b5deee435d3612947dd5636de231e3dbc1207cc867d617d4e9be"
    sha256 cellar: :any,                 big_sur:        "f4e5249349761c5e95024d8281e29ba0a90799e49fdbb20f4ec7d2654a2aef9c"
    sha256 cellar: :any,                 catalina:       "0c7a430fdd6d5f1346b4b0028c3540424da4783a089e293e650b3cb570ce7ccc"
    sha256 cellar: :any,                 mojave:         "7bf0526c0ecc82a745c63bb3c69d26259896592507c5be0b53e6709ccf435764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79748adfdc073f5db043f06467f9a722d3df3937c17541cd186c1262ae171b9a"
  end

  depends_on "poetry" => :build
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/86/ed/eb0468849a425a9ef0d15f789e2272bb5fc4081926f0261542927599177b/cli_helpers-2.2.0.tar.gz"
    sha256 "733f65d8c921e0cffa8f7ae4c8735bd7ecdffec383c5246f647ddd0fddb33448"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/db/15/6e89ae7cde7907118769ed3d2481566d05b5fd362724025198bb95faf599/pendulum-2.1.2.tar.gz"
    sha256 "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/8c/04/1f872b69366cf9ef6cd46b02897b21cd9d03435a6b7ca73c618ec1870bb5/pgspecial-1.13.0.tar.gz"
    sha256 "3847e205b19469f16ded05bda24b4758056d67ade4075a5ded4ce6628a9bad01"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/15/e4/f138d6319c02a6052a590ef32e94366b74581973b43665c2960b07b9ec24/prompt_toolkit-3.0.24.tar.gz"
    sha256 "1bb05628c7d87b645974a1bad3f17612be0c29fa39af9f7688030163f680bad6"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/d1/1e/b450599a27b1809bccbd4e369f397cb18dc56b875778d961f9ae180b54b7/psycopg2-2.9.3.tar.gz"
    sha256 "8e841d1bf3434da985cc5ef13e6f75c8981ced601fd70cc6bf33351b91562981"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytzdata" do
    url "https://files.pythonhosted.org/packages/67/62/4c25435a7c2f9c7aef6800862d6c227fc4cd81e9f0beebc5549a49c8ed53/pytzdata-2020.1.tar.gz"
    sha256 "3efa13b335a00a8de1d345ae41ec78dd11c9f8807f522d39850f2dd828681540"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/a1/7f/a1d4f4c7b66f0fc02f35dc5c85f45a8b4e4a7988357a29e61c14e725ef86/setproctitle-1.2.2.tar.gz"
    sha256 "7dfb472c8852403d34007e01d6e3c68c57eb66433fb8a5c77b13b89a160d97df"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/32/fe/8a8575debfd924c8160295686a7ea661107fc34d831429cce212b6442edb/sqlparse-0.4.2.tar.gz"
    sha256 "0c00730c74263a94e5a9919ade150dfc3b19c574389985446148402998287dae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    resource("pytzdata").stage do
      system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
      venv.pip_install Dir["dist/pytzdata-*.whl"].first
    end

    venv.pip_install resources.reject { |r| r.name == "pytzdata" }
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"pgcli", "--help"
  end
end
