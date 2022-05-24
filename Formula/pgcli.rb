class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/f8/2a/f23f103e28b32fe005862441c461c9b0022cb1dd4f7b248dd983440628d5/pgcli-3.4.1.tar.gz"
  sha256 "f03930187e27d60df658ca8a04fb601ec5d7476c735f2b1542c6adec5cac8fe2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b31c304fd56b94f055f1914db3cc9287ee3f59ced01436112cb70563da41960"
    sha256 cellar: :any,                 arm64_big_sur:  "d9471c9f20c489b5bd64303f182cdbdc01e93832e15f94fecc5f56e5f92c33ab"
    sha256 cellar: :any,                 monterey:       "75c22fb060f79aa267bc7b96b264bd79b2b849a4eeddd58c148af972f9a600a6"
    sha256 cellar: :any,                 big_sur:        "527933ff3f86990099d3b8f245c55ee8a341b900fd493a7a492148e647336cb7"
    sha256 cellar: :any,                 catalina:       "b26dbeed520bb6ca3bddca94a842f3b2358fc94102033d55c7503da2f67e1fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ea245bc0f3ed24ce08a7575a40eb5fc80a0459f8d0d013fb7d0a3128cd181aa"
  end

  depends_on "poetry" => :build
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/d9/5d/bd0b08f7f8f9d02f44055cf4b41aafa658c1b0731237f303b9fdb49fc8d7/cli_helpers-2.2.1.tar.gz"
    sha256 "0ccc1cfcda1ac64dc7ed83d7013055cf19e5979d29e56c21f3b692de01555aae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
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
    url "https://files.pythonhosted.org/packages/5e/eb/a5fe6dd01ededd9eb9a6400fd9a2bfa1e67a6c3f1f8cdb974d5a933d55c1/pgspecial-1.13.1.tar.gz"
    sha256 "d5dab96690908275916dc2c622efae217f142e08165fa366949d41cbc5658701"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/37/34/c34c376882305c5051ed7f086daf07e68563d284015839bfb74d6e61d402/prompt_toolkit-3.0.28.tar.gz"
    sha256 "9f1cd16b1e86c2968f2519d7fb31dd9d669916f515612c269d14e9ed52b51650"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/d1/1e/b450599a27b1809bccbd4e369f397cb18dc56b875778d961f9ae180b54b7/psycopg2-2.9.3.tar.gz"
    sha256 "8e841d1bf3434da985cc5ef13e6f75c8981ced601fd70cc6bf33351b91562981"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
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
