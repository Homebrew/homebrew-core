class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/d7/ff/10c1eb5fb8e4a81bb60abb4d13bfa04e27564fb7880915abdf603069cc93/pgcli-4.1.0.tar.gz"
  sha256 "3fd16c8b51bd0145ff618c2c73264bcd854ba866aa206d4f076851f641b9b215"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fb4f0a70fc463d076b8660f49b3d5d362c727460dc3e372a84e1a9c8f76ea63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c900de7dcf1861b5fec865d4682739c03343fe247bec41172ac97295055b78b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d6896131b3c90a7c76ee863060f64e2d212d66ea6225672c38a1ddfa8b8a351"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed316997fd008730c6a70543a05bfdbbc29f394c033dce1ed3dd94c557d64b57"
    sha256 cellar: :any_skip_relocation, ventura:        "9dd860dd4057735034e70b95fe8321222d1d8b6cef06064684527a1802ab023c"
    sha256 cellar: :any_skip_relocation, monterey:       "b320e72634550d8f0c38545e0e85e4de6c4b7f137e7ce899897b2e318bf38eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ff2c8f1a8a5bf995d64a0ba78f56dc60adb294cf0742e7bc991c6b845c5f0d7"
  end

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

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/2e/b8/52f0d19d80872df8ed2bbfc4569196e30d455d3b5f91659a6bf5c0d8e57e/pgspecial-2.1.1.tar.gz"
    sha256 "a38239cd961fac33ce6da35c466d758acb6f942901598d7df74e5b82fe6f5636"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/e5/b8/dc85a3b5d3576527c288197de5db85edd141d6ce27fcf73e9f77e871824a/psycopg-3.1.19.tar.gz"
    sha256 "92d7b78ad82426cdcf1a0440678209faa890c6e1721361c2f8901f0dccd62961"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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
    url "https://files.pythonhosted.org/packages/50/26/5da251cd090ccd580f5cfaa7d36cdd8b2471e49fffce60ed520afc27f4bc/sqlparse-0.5.0.tar.gz"
    sha256 "714d0a4932c059d16189f58ef5411ec2287a4360f17cdd0edd2d09d4c5087c93"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    venv = virtualenv_install_with_resources without: "psycopg"

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname = find_libpq_full_path()",
                                            "libname = '#{Formula["libpq"].opt_lib/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

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
