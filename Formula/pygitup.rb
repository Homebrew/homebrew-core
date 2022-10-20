class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/89/a3/35f7460cfaf7353ceb23442e5c250fda249cb9b8e26197cf801fa4f63786/git-up-2.1.0.tar.gz"
  sha256 "6e677d91aeb4de37e62bdc166042243313ec873c3caf9938911ac2e7f52a0652"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e501e75edc617658a74ab06bb460cc1bdc7340cc313de8eae83fe010bf49a539"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb768a4c87f4607df1886f4e3f39ede6372e9518496fe1cc89abc57b2ae17166"
    sha256 cellar: :any_skip_relocation, monterey:       "2922057161e4ea337bef801baa74b358d4408d82866d8589ea1406e68dd80b38"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4a7185c1f11520a82666c5a76d299eeee57153910040d5face3ce30223aba6f"
    sha256 cellar: :any_skip_relocation, catalina:       "6698e09a1cb0180abe22f1591e71fa6c94e8ec50b375138770d5bacf758b1759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e5f1dbbfbcf2039bc821d9abe1fcff41e4b7791b77a469729763f712eec1b8"
  end

  depends_on "poetry" => :build
  depends_on "python-typing-extensions"
  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/34/fe/9265459642ab6e29afe734479f94385870e8702e7f892270ed6e52dd15bf/gitdb-4.0.7.tar.gz"
    sha256 "96bf5c08b157a666fec41129e6d327235284cca4c81e92109260f353ba138005"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/34/cc/aaa7a0d066ac9e94fbffa5fcf0738f5742dd7095bdde950bd582fca01f5a/GitPython-3.1.24.tar.gz"
    sha256 "df83fdf5e684fef7c6ee2c02fc68a5ceb7e7e759d08b694088d0cacb4eba59e5"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/dd/d4/2b4f196171674109f0fbb3951b8beab06cd0453c1b247ec0c4556d06648d/smmap-4.0.0.tar.gz"
    sha256 "7e65386bd122d45405ddf795637b7f7d2b532e7e401d46bbe3fb49b9986d5182"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install resources
    system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
    venv.pip_install_and_link Dir["dist/git_up-*.whl"].first
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "git", "clone", "https://github.com/Homebrew/install.git"
    cd "install" do
      assert_match "Fetching origin", shell_output("#{bin}/git-up")
    end
  end
end
