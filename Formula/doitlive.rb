class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e5/d9/4ce969d98f521c253ec3b15a0c759104a01061ac90fb9d8636b015bcb4ea/doitlive-4.3.0.tar.gz"
  sha256 "4cb1030e082d8649f10a61d599d3ff3bcad7f775e08f0e68ee06882e06d0190f"
  license "MIT"
  revision 10
  head "https://github.com/sloria/doitlive.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca1a1f1aea885860e82beada9dff81d971f89acbac90e872279a1b74d196c566"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c53819a626934205ac4b32eadb316fc4c3bf287fccc513ff313396bedd002dad"
    sha256 cellar: :any_skip_relocation, monterey:       "18a0656dfd0262f370d21919bb0a2649edc63c3be6295edee3feb50aa6d493c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cbd6954dd362112f2a1a9eb1226ea506721eb64efe37af548359eef5f116410"
    sha256 cellar: :any_skip_relocation, catalina:       "0099d450d5512214450d1eec180df1b1b18e114a2b7e9255e720c31dc5c42449"
    sha256 cellar: :any_skip_relocation, mojave:         "5414c94f952d6394a59752a9e4f6e3a303e93eeb6722a64fd0eba975dcc2ee57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d33aec040b27e6d8786e005911c0ab20e2201cecb7694bcdafc46d4ef29e78e"
  end

  depends_on "python@3.10"

  resource "click" do
    url "https://files.pythonhosted.org/packages/4e/ab/5d6bc3b697154018ef196f5b17d958fac3854e2efbc39ea07a284d4a6a9b/click-7.1.1.tar.gz"
    sha256 "8a18b4ea89d8820c5d0c7da8a64b2c324b4dabb695804dbfea19b9be9d88c0cc"
  end

  resource "click-completion" do
    url "https://files.pythonhosted.org/packages/93/18/74e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406/click-completion-0.5.2.tar.gz"
    sha256 "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/9f/79/d265d783dd022541b744d002745d9e55d84c04a41930e35d8795934f6526/click-didyoumean-0.0.3.tar.gz"
    sha256 "112229485c9704ff51362fe34b2d4f0b12fc71cc20f6d2b3afabed4b8bfa6aeb"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/d8/03/e491f423379ea14bb3a02a5238507f7d446de639b623187bccc111fbecdf/Jinja2-2.11.1.tar.gz"
    sha256 "93187ffbc7808079673ef52771baa950426fd664d3aad1d0fa3e95644360e250"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/4b/f0/39516ebeaca978d6607609a283b15e7637622faffc5f01ecf78a49b24cd5/shellingham-1.3.2.tar.gz"
    sha256 "576c1982bea0ba82fb46c36feb951319d7f42214a82634233f58b40d858a751e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  def install
    virtualenv_install_with_resources

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, libexec/"bin/doitlive", "completion")
    (bash_completion/"doitlive").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, libexec/"bin/doitlive", "completion")
    (zsh_completion/"_doitlive").write output
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
