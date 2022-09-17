class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/a7/2c/5ec926b4ef08c23126875e29923bb803f2aee56d597aa248d429385d2887/pgcli-3.5.0.tar.gz"
  sha256 "cc448d95159fc0903d36182992778a096eda5752d660d47671383c8e2bf633f1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a86a5fe63ba8444ed87af033f5420e6fda24f78b9139e9dfd38d13e225a66cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f8ba583365857b871956bcf7c9482f901ada3b09c7f711009489a328e644e61"
    sha256 cellar: :any_skip_relocation, monterey:       "2acb1d2b07fa6a17f91f5398cadc2ef6c0510f6ad505f9f1c2810ccec9b8aa1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "86471c724a09aa3ff39b80042110255f19e2cff6762f1d14c9917784e26cce64"
    sha256 cellar: :any_skip_relocation, catalina:       "1715d228c488aef2c1194c2af6545cb8f1c74a88113953fb8ee43a0964f8bceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c41815443ed8a3915d8bcbecacdffc635d0ccd42c12f4e623e187cd2e7ea6a33"
  end

  depends_on "poetry" => :build
  depends_on "libpq"
  depends_on "libpython-tabulate"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/d9/5d/bd0b08f7f8f9d02f44055cf4b41aafa658c1b0731237f303b9fdb49fc8d7/cli_helpers-2.2.1.tar.gz"
    sha256 "0ccc1cfcda1ac64dc7ed83d7013055cf19e5979d29e56c21f3b692de01555aae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
    url "https://files.pythonhosted.org/packages/64/4d/e135172d93a1870897dbc01483f12b80c7f251ee08b583ec11a4b5888a08/pgspecial-2.0.1.tar.gz"
    sha256 "64443bbc9ad09b57d0f4dcbb38eff44d52853b7418c9ea52f5857abe1bb534ec"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/3e/9b/2af032b1befdfdb8c9af1cf9e88cf1b3ad54b03d0135af3f60e421e6befc/psycopg-3.1.1.tar.gz"
    sha256 "3ee0af9cf944d9579441c15702835a949788b5a57894823f0a916c2598c96f40"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
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
    url "https://files.pythonhosted.org/packages/b5/47/ac709629ddb9779fee29b7d10ae9580f60a4b37e49bce72360ddf9a79cdc/setproctitle-1.3.2.tar.gz"
    sha256 "b9fb97907c830d260fa0658ed58afd48a86b2b88aac521135c352ff7fd3477fd"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/32/fe/8a8575debfd924c8160295686a7ea661107fc34d831429cce212b6442edb/sqlparse-0.4.2.tar.gz"
    sha256 "0c00730c74263a94e5a9919ade150dfc3b19c574389985446148402998287dae"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname = find_libpq_full_path()",
                                            "libname = '#{Formula["libpq"].opt_lib/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    resource("pytzdata").stage do
      system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
      venv.pip_install Pathname.glob("dist/pytzdata-*.whl").first
    end

    skip = %w[psycopg pytzdata]
    venv.pip_install resources.reject { |r| skip.include? r.name }
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"pgcli", "--help"
  end
end
