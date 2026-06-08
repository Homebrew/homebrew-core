class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/e0/ca/b081f0ae381425f87dd751b449c33aca7398c2183799fc56501fe7c26975/pgcli-4.5.0.tar.gz"
  sha256 "9dce07f5b628068156256cb818e5191a773afe6eeb7054f210fa892813625e3e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06c83ddbb81fa0e4d307a2398b21c5cb9a2f44a5b415e3c6a85e74acc4b1028a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d50f821bcfd38fcc49c0f7c930055537919dcf1811e385d7845b438966f8af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3064eb2ace850c26aebbfd1a9eb687571aba4d777293bb10436387afa21b9ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "6686534b552e5361011ba4509a17e0216b5566ceabda76cc847a94d27ce3245b"
    sha256 cellar: :any,                 arm64_linux:   "951722d37b58ee9bf328392f1b6ed96936e1e3d271fc1ca5eb23c9141abe16ac"
    sha256 cellar: :any,                 x86_64_linux:  "cfaea142b4106f8d6b6f81a4bba46b3144096193bc2a12878528ee400b34105b"
  end

  depends_on "libpq"
  depends_on "python@3.14"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/5e/d1/f83191ae4a8f6584876bc63e5e1ae39360f4de7ed74cce76f266ef9d5d10/cli_helpers-2.15.0.tar.gz"
    sha256 "c2c5a1a5fd6a8ad51b1b99e80685cd04c006b0e29cacf4c24b1ba8a440ea8d4d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/12/b3/f342d6a9ec37fddff8c30b4f6eb5e83990f5d33135cecf381d3f7a0c1c9c/pgspecial-2.2.1.tar.gz"
    sha256 "da6c7fcc7bef7bb0132dc2046f74ec6513b1fe6f0c80e5528d630d14b7c4849d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/db/2f/cb91e5502ec9de1de6f1b76cfbf69531932725361168bb06963620c77e2e/psycopg-3.3.4.tar.gz"
    sha256 "e21207764952cff81b6b8bdacad9a3939f2793367fdac2987b3aac36a651b5bc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/90/76/437d71068094df0726366574cf3432a4ed754217b436eb7429415cf2d480/sqlparse-0.5.5.tar.gz"
    sha256 "e20d4a9b0b8585fdf63b10d30066c7c94c5d7a7ec47c889a2d83a3caa93ff28e"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    venv = virtualenv_install_with_resources without: "psycopg"

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname := find_libpq_full_path()",
                                            "libname := '#{Formula["libpq"].opt_lib/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"pgcli", shell_parameter_format: :click)
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
