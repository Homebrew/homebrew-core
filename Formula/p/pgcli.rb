class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/ab/9a/c86de44b7a663f0a15cb835d317f22f2ef8438154f6b646ffe32baa3799d/pgcli-4.3.0.tar.gz"
  sha256 "765ae1550c5508a481f19f16a99716c253fe91afb255797add2d635da20b6aef"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c94fe9b94951859f7ae906c57baba733adf00dc5f1fcfff6323ad0342bb517a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7242c372c8216ae21576bcc4a446bbe3b41fbcbc5e2e20e3b7b82474541e416"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa6197e523dfa68d26564db1da6fc4d8db2185c4891cec5bd2f7f0a6d1e54b4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d5a3cbee22958f4352243b85b8b762c55404c26d8de4474656f9a2da5814a21"
    sha256 cellar: :any_skip_relocation, ventura:       "393f05d8cf7191679029acba7ded5c126ef90e064cb9b8d3ed781693790fe766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e15814871dc8fc3a7e6ddd94a4ee0a79b8aed7b11aef6302eb59252a2ce80681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8fb9bf4416e8568cfbd768480ef55024d770204790d947732bed7ba606cac0"
  end

  depends_on "libpq"
  depends_on "python@3.13"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/f9/7c/3344a9b856b9582df36c7a525f5710294f349499d16dcbf343453f70bdb8/cli_helpers-2.4.0.tar.gz"
    sha256 "55903b705a212a473731db20fa26f58655e354078b99cb13c99ec06940287a4d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/b6/bd/21d05caf4c66b87abb4f1a7340ac2596f10087e9f60b95c84369febcf377/pgspecial-2.1.3.tar.gz"
    sha256 "6d4d2316aff7d47954db99d4c391d6c0bb26568ebcb9d151f65dab7938b6cbe2"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/e1/bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854/prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/67/97/eea08f74f1c6dd2a02ee81b4ebfe5b558beb468ebbd11031adbf58d31be0/psycopg-3.2.6.tar.gz"
    sha256 "16fa094efa2698f260f2af74f3710f781e4a6f226efe9d1fd0c37f384639ed8a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/c4/4d/6a840c8d2baa07b57329490e7094f90aac177a1d5226bc919046f1106860/setproctitle-1.3.5.tar.gz"
    sha256 "1e6eaeaf8a734d428a95d8c104643b39af7d247d604f40a7bebcf3960a853c5e"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/e5/40/edede8dd6977b0d3da179a342c198ed100dd2aba4be081861ee5911e4da4/sqlparse-0.5.3.tar.gz"
    sha256 "09f67787f56a0b16ecdbde1bfc7f5d9c3371ca683cfeaa8e6ff60b4807ec9272"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
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
