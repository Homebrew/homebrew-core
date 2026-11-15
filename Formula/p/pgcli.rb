class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/3e/bd/66e94c76c8e3e52d9194eec079ab2b7a253896e6b1422d0c726094955299/pgcli-4.7.1.tar.gz"
  sha256 "195d00ae994c89d43ed8e570ddfa0a9fb6105e6b783dfc1eb6cea9b326dc3346"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0a1e4963f8c8f87bf9ffb0ddfbbd9fa856650d77df38bc6132fdebdba7c3b15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b15fcb4a3367e0b2aceeab086e5d3590f7af3d6064157be94f655f20c3c866ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f85c3033bab150e4b4112c74615aa7c7e84fddd88e7f459f0a2c4d78a3d0a78e"
    sha256 cellar: :any,                 arm64_linux:       "252b700aacff1e62e2580e725b5a40fb659eb7862c1c37d1a9dc7ac808cb0a3f"
    sha256 cellar: :any,                 x86_64_linux:      "eb4430d36e883d9d1277c9fd72dafdd80c908aeb94d9d811647600ffb91bef6f"
  end

  depends_on "libpq"
  depends_on "python@3.15"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/3f/de/278f4885fcd03661ab9b69dba9fc745c27d820858dbc06e427057899dcf5/cli_helpers-2.15.1.tar.gz"
    sha256 "e9c0826dda2855745eb63b3fd8e33b6ac8881188f2ba91e51a516ed833fc0cb8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
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
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/76/26/3ea4ca5eaea1c0debcdf7ee7c1613fbe721dc27a03c461c0817ffd8a0601/psycopg-3.3.6.tar.gz"
    sha256 "c081f2250df751a943036e42db6df4571c66cd0aabe8291a7a506512b12007d2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/49/b0/6b8a516c5a9e9630bd5293db78314ac012f690305fe93beadea388626efb/setproctitle-1.3.8.tar.gz"
    sha256 "cafe209d064a6efb88cb45a03e97981ff8832802b2b5d009dde0197a3b7b41c8"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/5f/d3/3f06a1006f2261d1342aefb3c71eed02f5d4ca5bdbecd86ebc12ad38306e/sqlparse-0.6.0.tar.gz"
    sha256 "113c35c75365ab9cc9c7231d68c6428fb11c085fc8e9eb1ad659b7ddbf6cd2b9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    venv = virtualenv_install_with_resources without: "psycopg"

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname := find_libpq_full_path()",
                                            "libname := '#{formula_opt_lib("libpq")/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"pgcli", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgcli --version")
    (testpath/"pgclirc").write <<~EOS
      [alias_dsn]
      homebrew_dsn = postgresql://homebrew:password@localhost/dbname
    EOS
    assert_match "homebrew_dsn", shell_output("#{bin}/pgcli --pgclirc=#{testpath}/pgclirc --list-dsn")
  end
end
