class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/a7/2c/5ec926b4ef08c23126875e29923bb803f2aee56d597aa248d429385d2887/pgcli-3.5.0.tar.gz"
  sha256 "cc448d95159fc0903d36182992778a096eda5752d660d47671383c8e2bf633f1"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d331c62de6055634aa7e32f6796b9e216868c42ed4444290c6755436413f412d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0c1bd3cb3411d770d00787985c31d3bc967a231fcac021142c2e72a8889e578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bbea1d37a2b83bcf14fdcf1f357a08a1bb2e10d630c7cd71bf438e58a4731c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "adfeb0b4b4999c11084378aa6f4d95650d6a6f5adaa76fcfc839118d1ce574db"
    sha256 cellar: :any_skip_relocation, ventura:        "893cdbcd80ab264689e0bdf527378f6c668c98aff7964a0afc7167458469a15a"
    sha256 cellar: :any_skip_relocation, monterey:       "dc94343f65e6d50ca658ca37f940329d18da8c1865cc1224be192124cca0e993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d2b2a793e14bef7261d5a25bc0e6045a6843caa5ca14d64c3951db8101d18e"
  end

  depends_on "libpq"
  depends_on "pygments"
  depends_on "python-tabulate"
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
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/db/15/6e89ae7cde7907118769ed3d2481566d05b5fd362724025198bb95faf599/pendulum-2.1.2.tar.gz"
    sha256 "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/2a/77/93b39f02da1acd73fe8d775329b7fdd4ef394101c6e52f6ef715f8fe6003/pgspecial-2.1.0.tar.gz"
    sha256 "099a9c43b5768885a99c761b1f14a8c6504bb14e9631ad8755739adaf758266f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/ef/52/bfc1d7d82467594a45d46cf5ecae1cd5e6009ec851f4cff1f239d0f32730/psycopg-3.1.8.tar.gz"
    sha256 "59b4a71536b146925513c0234dfd1dc42b81e65d56ce5335dff4813434dbc113"
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
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
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

    generate_completions_from_executable(bin/"pgcli", shells: [:fish, :zsh], shell_parameter_format: :click)
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
