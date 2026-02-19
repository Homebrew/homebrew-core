class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/98/9d/193acc7d3236e5941c02044787bd33afb668d33f72375d1ba3b4f5e92128/pgcli-4.4.0.tar.gz"
  sha256 "bd5f8d68af28fd69551a3cb48a2849cad5f6854aa48022e9d98c6236d109eeae"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "004f815714f5c5de83aa18d28df0e8217d8b3a0ea4a242f93e279faaa518e1c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3a22d56e459b6d8e2d39b8551771fb62bcc0bd2a4a1dc591231e07655f650ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "108013e4b16fd2e411564138fec9f11e5de4f17233d2823ec2f8245313bf1867"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb49c84a1e4eb67b1ea78a24113e1648c4236dd8ec26ba7f9506f20c97b735e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9f1d47b9524844576959e612345de92b48d823771aebf80d0fce5cfc843be5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5bcb06cabe91976eac46824f0c837954d1f62f73755a9de9bc7d4ce7078c395"
  end

  depends_on "libpq"
  depends_on "python@3.14"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/5a/e6/51b043e8c4ae390af61af35f73a9c2a69a26ea9cf4d061ab45c59f8e20f4/cli_helpers-2.7.0.tar.gz"
    sha256 "62d11710dbebc2fc460003de1215688325d8636859056d688b38419bd4048bc0"
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
    url "https://files.pythonhosted.org/packages/12/b3/f342d6a9ec37fddff8c30b4f6eb5e83990f5d33135cecf381d3f7a0c1c9c/pgspecial-2.2.1.tar.gz"
    sha256 "da6c7fcc7bef7bb0132dc2046f74ec6513b1fe6f0c80e5528d630d14b7c4849d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/e0/1a/7d9ef4fdc13ef7f15b934c393edc97a35c281bb7d3c3329fbfcbe915a7c2/psycopg-3.3.2.tar.gz"
    sha256 "707a67975ee214d200511177a6a80e56e654754c9afca06a7194ea6bbfde9ca7"
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
    url "https://files.pythonhosted.org/packages/90/76/437d71068094df0726366574cf3432a4ed754217b436eb7429415cf2d480/sqlparse-0.5.5.tar.gz"
    sha256 "e20d4a9b0b8585fdf63b10d30066c7c94c5d7a7ec47c889a2d83a3caa93ff28e"
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
