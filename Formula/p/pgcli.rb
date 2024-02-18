class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/08/a7/448bcaf13dbcb4bd00c4f62fea1b2b491958653646da41c785755df6235f/pgcli-4.0.1.tar.gz"
  sha256 "f2feea2099ce1ad5e8a9d5d93b0edaf60dc61e97b21b75e91d9723939ce53bd2"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "111270390ca36cdfbfba08caefaa096ed77f2cc786ac529bec3237552627410e"
    sha256 cellar: :any,                 arm64_ventura:  "bd89eb8b14c6ab320f71b4abdf7f375cf675ff9241d75cdb3a7564df5b78478d"
    sha256 cellar: :any,                 arm64_monterey: "44cad64af47ffc66573ed18b7110a68347a73329b07c61bc056e373a7711e4ca"
    sha256 cellar: :any,                 sonoma:         "cc098f4f3820865894e417baf19496ec783e22fb47dbe4f841b05870d5ff3b40"
    sha256 cellar: :any,                 ventura:        "0bbf0e7b7256042df4d7c7011b93040242c0968188c51f6e61f5034bf7915a91"
    sha256 cellar: :any,                 monterey:       "4cf802c37001d28f748a64d08903178ad47759a5ba52e122e3969647715c4bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a081778eeccb3061f1dae055d5c95c20f36dd63ccb4faa5e882212f6868c3a7"
  end

  depends_on "rust" => :build # for pendulum
  depends_on "libpq"
  depends_on "python@3.12"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/ab/de/79529bd31c1664415d9554c0c5029f2137afe9808f35637bbcca977d9022/cli_helpers-2.3.1.tar.gz"
    sha256 "b82a8983ceee21f180e6fd0ddb7ca8dae43c40e920951e3817f996ab204dae6a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/b8/fe/27c7438c6ac8b8f8bef3c6e571855602ee784b85d072efddfff0ceb1cd77/pendulum-3.0.0.tar.gz"
    sha256 "5d034998dea404ec31fae27af6b22cff1708f830a1ed7353be4d1019bb9f584e"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/2e/b8/52f0d19d80872df8ed2bbfc4569196e30d455d3b5f91659a6bf5c0d8e57e/pgspecial-2.1.1.tar.gz"
    sha256 "a38239cd961fac33ce6da35c466d758acb6f942901598d7df74e5b82fe6f5636"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/31/4d/43deb2a892b95875672df8fb34fcbff1345214f96d94ff49206871576fc0/psycopg-3.1.18.tar.gz"
    sha256 "31144d3fb4c17d78094d9e579826f047d4af1da6a10427d91dfcfb6ecdf6f12b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "time-machine" do
    url "https://files.pythonhosted.org/packages/48/50/d0c443bc1287dc20a22597346864175774d39f40239223f95fb03d70a044/time_machine-2.13.0.tar.gz"
    sha256 "c23b2408e3adcedec84ea1131e238f0124a5bc0e491f60d1137ad7239b37c01a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname = find_libpq_full_path()",
                                            "libname = '#{Formula["libpq"].opt_lib/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "psycopg" }
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
