class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/ab/9a/c86de44b7a663f0a15cb835d317f22f2ef8438154f6b646ffe32baa3799d/pgcli-4.3.0.tar.gz"
  sha256 "765ae1550c5508a481f19f16a99716c253fe91afb255797add2d635da20b6aef"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "320d3eb85c0ef74dcb5b151e8cdfa9d021d71ba79fedc91c84dc5e8409d3bf5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6149460db9343c9b77cce05134380a52141ebf53bcb3faab02a5088aacdb1f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6701e5f1e0d9291df5de2d02aae08780abb58aab198c76ed666bd5d688163a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "66d3728a035658eee88d033e59910ea16ca486a4fde8b8fbd3854e6f2d16645c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4813a183b63cf5c4c1ebfd82bc031a4cacabe87334b48f205fa9b9ac1d746468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314d231e51a99b069f55582e24f254b4b24ae70382ca3c2a93d068952476846e"
  end

  depends_on "libpq"
  depends_on "python@3.14"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/5a/e6/51b043e8c4ae390af61af35f73a9c2a69a26ea9cf4d061ab45c59f8e20f4/cli_helpers-2.7.0.tar.gz"
    sha256 "62d11710dbebc2fc460003de1215688325d8636859056d688b38419bd4048bc0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
    url "https://files.pythonhosted.org/packages/a9/f1/0258a123c045afaf3c3b60c22ccff077bceeb24b8dc2c593270899353bd0/psycopg-3.2.10.tar.gz"
    sha256 "0bce99269d16ed18401683a8569b2c5abd94f72f8364856d56c0389bcd50972a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
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
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
