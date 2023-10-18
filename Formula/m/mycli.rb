class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/20/9b/8909b7ce779ca87b10826e01a6073890937e44e44a60b1f4d2ee71f44ce6/mycli-1.27.0.tar.gz"
  sha256 "a71db5bd9c1a7d0006f4f2ff01548ce75637d3f50ca3a7e77b950b5b46aff7cd"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b912e5f834281a7956503d856e84c015bd3221d5359e203e7d6b4f430f30fd66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d866d3e248bbe263c8ea578bd60bf5bc165aa1e7f7b2619fa06bf073511131e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46120e195909bfa13de1cd443508d1f60918cb68e6204960e0f14e1ce94d4cdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb4628dc32cd4dc299e21cf633e5c357746854266175abbec6bc8bf27e62fb80"
    sha256 cellar: :any_skip_relocation, ventura:        "5d603932c673eafac54101a33bc71673f7e2749fe6c05eed41811ff8c78cb4fb"
    sha256 cellar: :any_skip_relocation, monterey:       "bd5b2ae8a3d96f4e8772cfb8b3d73a8aeca7f75fcd189001fe6a51477ca598f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea85758a2715c1689703e146aa5e0ba7274e0b4e456c77fe785af6dd12c4184"
  end

  depends_on "cffi"
  depends_on "pygments"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
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
    url "https://files.pythonhosted.org/packages/c1/b1/c0bda67234171f4d88ee936f4a7810275fceded0ed974dac893ebc0d4bd2/sqlglot-18.14.0.tar.gz"
    sha256 "e2b2f16598830e8acd5ffbe55e19c2e45af7e27596692c3214cf4cc1be82027b"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
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
