class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/a7/2c/5ec926b4ef08c23126875e29923bb803f2aee56d597aa248d429385d2887/pgcli-3.5.0.tar.gz"
  sha256 "cc448d95159fc0903d36182992778a096eda5752d660d47671383c8e2bf633f1"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "785fdcf905c4f10654079a77c1e8e8a2824c2900787f58bcae176a3402e1ca74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce74a9c059e119528d56e7bbf1b817d67decf66bfbb72e7dfb6f39587110c4a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d33b67f1daeb419af9360d7a8d8d7c674c8fb0b25bed4cc5deb83205b4637c3e"
    sha256 cellar: :any_skip_relocation, monterey:       "f07b2338c76fa3a16bc06cb08b85908834dfe94fa52f8ccaabe0addc7d31a3e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "120f31ad788fac40ecac7e6343d3fafb6ed5b5e994b68174e10cfba0c2e55435"
    sha256 cellar: :any_skip_relocation, catalina:       "13064c4b21d90cbfd7a28f3fb1a3772595a3bba59ccc732ffcbcd1ff83e44d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43428d5c88187890c44be136e532e347c55e3a4798398b9a43035b92899dd668"
  end

  depends_on "libpq"
  depends_on "libpython-tabulate"
  depends_on "openssl@1.1"
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
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
    url "https://files.pythonhosted.org/packages/c4/6e/6ff7938f47981305a801a4c5b8d8ed282b58a28c01c394d43c1fbcfc810b/prompt_toolkit-3.0.33.tar.gz"
    sha256 "535c29c31216c77302877d5120aef6c94ff573748a5b5ca5b1b1f76f5e700c73"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/e1/06/4d054820a210c923b03aca019717724e4d55a042bc1dea2b8cff663c1169/psycopg-3.1.4.tar.gz"
    sha256 "6874dbaba583cc6663437604bf45f7c244b5fd702f88af6211cd5a74e8ee3a8a"
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
    url "https://files.pythonhosted.org/packages/ba/fa/5b7662b04b69f3a34b8867877e4dbf2a37b7f2a5c0bbb5a9eed64efd1ad1/sqlparse-0.4.3.tar.gz"
    sha256 "69ca804846bb114d2ec380e4360a8a340db83f0ccf3afceeb1404df028f57268"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname = find_libpq_full_path()",
                                            "libname = '#{Formula["libpq"].opt_lib/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when merged/released: https://github.com/sdispater/pytzdata/pull/13
    resource("pytzdata").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=1.0.0"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install_and_link Pathname.pwd
    end

    skip = %w[psycopg pytzdata]
    venv.pip_install resources.reject { |r| skip.include? r.name }
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "Invalid DSNs found in the config file", shell_output("#{bin}/pgcli --list-dsn 2>&1", 1)
    (testpath/"pgclirc").write <<~EOS
      [alias_dsn]
      homebrew_dsn = postgresql://homebrew:password@localhost/dbname
    EOS
    assert_match "homebrew_dsn", shell_output("#{bin}/pgcli --pgclirc=#{testpath}/pgclirc --list-dsn")
  end
end
