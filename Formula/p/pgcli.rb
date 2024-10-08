class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/d7/ff/10c1eb5fb8e4a81bb60abb4d13bfa04e27564fb7880915abdf603069cc93/pgcli-4.1.0.tar.gz"
  sha256 "3fd16c8b51bd0145ff618c2c73264bcd854ba866aa206d4f076851f641b9b215"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "463a77e7571e19ac4a23632e554e8f6b0750ee4535192fad61dc7db291af7c3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d8ef964efb0f562e18a25c34e1dd7281ac795e82ed222ad9b39dbbceaa4cbcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75cfe78f6e7d9e3d18390b558e75646391bfa5046bb372d9cf57ee946fbdd2f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ac39ef72d8042b39ee014d9764c2e37afbfea4ebdbe61a0da80fc9c797ddf34"
    sha256 cellar: :any_skip_relocation, ventura:       "9c4c379e59ce6ab673d05dc6fe0d2578ba7312e414a0bc3171e46b655b7334d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4efed42bcca9af8baaf6d54f5a300e57ae22dd5f34a797a1e4f1a8d07ca0a274"
  end

  depends_on "libpq@17"
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
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/3b/4c/5eece5ad87915a24e59c1f8adca6e2ae44368e5f7fdfcf9143a741a92161/pgspecial-2.1.2.tar.gz"
    sha256 "f0419e1b3b78fb3a72fe3b546f6788a712091532d599fe7593b5f6ee55a88f87"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/47/6d/0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879f/prompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/fe/70/d1e4c251be6e0752cbc7408f0556f8f922690837309442b9019122295712/psycopg-3.2.2.tar.gz"
    sha256 "8bad2e497ce22d556dac1464738cb948f8d6bab450d965cf1d8a8effd52412e0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/73/82/dfa23ec2cbed08a801deab02fe7c904bfb00765256b155941d789a338c68/sqlparse-0.5.1.tar.gz"
    sha256 "bb6b4df465655ef332548e24f08e205afc81b9ab86cb1c45657a7ff173a3a00e"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
