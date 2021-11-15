class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/89/a3/35f7460cfaf7353ceb23442e5c250fda249cb9b8e26197cf801fa4f63786/git-up-2.1.0.tar.gz"
  sha256 "6e677d91aeb4de37e62bdc166042243313ec873c3caf9938911ac2e7f52a0652"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1fc3d05c9426628db3014aad4ca9f54c3ea8ed709187e532c5e0a33ff3cec24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "691cecd76ff02753813853585aa00200c059a91cc729def69d4b3249b8045989"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd2171b041258c2674f34efb02a3f0a4e261defac4ff126f623c1d84def433e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a420f93c1cadfb852e6e38735b0990ee3981bfe9a7daa413e0a2a5901e07ded9"
    sha256 cellar: :any_skip_relocation, catalina:       "0bb8b6b27418770fd4073ba87ca325aff9402bade15bd914dbdbb0b6181f0a65"
    sha256 cellar: :any_skip_relocation, mojave:         "1728a7aaeaef7bb0f4fd323df92427d81a7fb274443cd9624a5e3009463ae563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f56cfd288b6c4c06519cfd4502adb34803da2a30beb6de0535ec5e5a6d54a49"
  end

  depends_on "poetry" => :build
  depends_on "python@3.9"

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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
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
