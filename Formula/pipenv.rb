class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://pipenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/be/c5/a7c300c4589e898db8cfcf26f7065c24e2f5abacaea196a7f80e6695344d/pipenv-2021.5.29.tar.gz"
  sha256 "05958fadcd70b2de6a27542fcd2bd72dd5c59c6d35307fdac3e06361fb06e30e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ad313f878cf10671754962f077eeb90b0a1c8d0acdec2513753fc48b19c61017"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c2c17225157ba5ded4484e51327548892dbab22532e993e277c3b85afbab70c"
    sha256 cellar: :any_skip_relocation, catalina:      "44fd41548a1ae7c63c610d3fdb3447e7191a761c86a62caf948457413120f21a"
    sha256 cellar: :any_skip_relocation, mojave:        "3996b20d3f9d8f869d876b2976bed9bbe325e8206cbffcdfbcd282cd024c671f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bda43e658fabc55db4fdde1ec6b048126b2aaadc0d98397396c73e5a6f4df9be"
  end

  depends_on "python@3.10"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/45/97/15fdbef466e12c890553cebb1d8b1995375202e30e0c83a1e51061556143/distlib-0.3.2.zip"
    sha256 "106fef6dc37dd8c0e2c0a60d3fca3e77460a48907f335fa28420463a6f799736"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/7c/46/4d4c37b6d96eb06961f8b2f38f7df12bb1a4951ff1145ac5dead9977e674/virtualenv-20.4.7.tar.gz"
    sha256 "14fdf849f80dbb29a4eb6caa9875d476ee2a5cf76a5f5415fa2f1606010ab467"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/1d/51/076f3a72af6c874e560be8a6145d6ea5be70387f21e65d42ddd771cbd93a/virtualenv-clone-0.5.4.tar.gz"
    sha256 "665e48dd54c84b98b71a657acb49104c54e7652bce9c1c4f6c6976ed4c827a29"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    env = {
      PATH: "#{libexec}/tools:$PATH",
    }
    (bin/"pipenv").write_env_script(libexec/"bin/pipenv", env)

    output = Utils.safe_popen_read(
      { "PIPENV_SHELL" => "bash" }, libexec/"bin/pipenv", "--completion", { err: :err }
    )
    (bash_completion/"pipenv").write output

    output = Utils.safe_popen_read(
      { "PIPENV_SHELL" => "zsh" }, libexec/"bin/pipenv", "--completion", { err: :err }
    )
    (zsh_completion/"_pipenv").write output
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
