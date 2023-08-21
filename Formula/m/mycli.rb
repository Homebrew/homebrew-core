class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/20/9b/8909b7ce779ca87b10826e01a6073890937e44e44a60b1f4d2ee71f44ce6/mycli-1.27.0.tar.gz"
  sha256 "a71db5bd9c1a7d0006f4f2ff01548ce75637d3f50ca3a7e77b950b5b46aff7cd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27b5792812b88a9a3e706e8a5951a83a4db14770c6afa664d5cfcbf4369eb591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd5408630fea5d0f2d2804a225851f28eb5f95ba594ef38ae67bcbff752b8801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f71c0f0cd6c27b10d6249e5aedacb2a6d4f696a4b4fc9b2cf9108b9aaf324aa"
    sha256 cellar: :any_skip_relocation, ventura:        "f09ad4f6423cffdafac55d6c3ff25c8f387152d16956a1c210897e97e944d0d2"
    sha256 cellar: :any_skip_relocation, monterey:       "47f73a701750081458d59cdd243c68d4914c25f3e43787bd24ef2fa02a92cfd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a6f4d0e2701d65a9f5c312900f2b5e4c7d00bab9e8234e41a791a0ab7203279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52a42f6feb4b9742a0a15964267fd0a3f52db1919195b52e80e29518c69a7fae"
  end

  depends_on "cffi"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/41/9d/ee68dee1c8821c839bb31e6e5f40e61035a5278f7c1307dde758f0c90452/PyMySQL-1.1.0.tar.gz"
    sha256 "4f13a7df8bf36a51e81dd9f3605fede45a4878fe02f9236349fd82a3f0612f96"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/76/2c/4cc0fdcf9c19be4dacceb9c513fa65a11e3f0e1905d7b7c8c72e10b1c4d8/sqlglot-17.11.0.tar.gz"
    sha256 "28a922a05274f03969632ee1a1e37d57fe6a2da30d8ff14090f42e567d30863d"
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
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"mycli", shells:                 [:fish, :zsh],
                                                      shell_parameter_format: :click)
  end

  test do
    system bin/"mycli", "--help"
  end
end
