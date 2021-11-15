class Gitup < Formula
  include Language::Python::Virtualenv

  desc "Update multiple git repositories at once"
  homepage "https://github.com/earwig/git-repo-updater"
  url "https://files.pythonhosted.org/packages/7f/07/4835f8f4de5924b5f38b816c648bde284f0cec9a9ae65bd7e5b7f5867638/gitup-0.5.1.tar.gz"
  sha256 "4f787079cd65d8f60c5842181204635e1b72d3533ae91f0c619624c6b20846dd"
  license "MIT"
  revision 5
  head "https://github.com/earwig/git-repo-updater.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff1d31029cc66522b235ec285341133a1074781dd57ff709e53caccb305ba3ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff1d31029cc66522b235ec285341133a1074781dd57ff709e53caccb305ba3ee"
    sha256 cellar: :any_skip_relocation, monterey:       "75fd26446950358870cfd58d35f9f354ea7e64c8cda02672e35ee43288a40796"
    sha256 cellar: :any_skip_relocation, big_sur:        "75fd26446950358870cfd58d35f9f354ea7e64c8cda02672e35ee43288a40796"
    sha256 cellar: :any_skip_relocation, catalina:       "75fd26446950358870cfd58d35f9f354ea7e64c8cda02672e35ee43288a40796"
    sha256 cellar: :any_skip_relocation, mojave:         "75fd26446950358870cfd58d35f9f354ea7e64c8cda02672e35ee43288a40796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab75d63b467bb90432d40c39999e7d3524fc5ef7bff426be0d8aec63f256b093"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/d1/05/eaf2ac564344030d8b3ce870b116d7bb559020163e80d9aa4a3d75f3e820/gitdb-4.0.5.tar.gz"
    sha256 "c9e1f2d0db7ddb9a704c2a0217be31214e91a4fe1dea1efad19ae42ba0c285c9"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ec/4d/e6553122c85ec7c4c3e702142cc0f5ed02e5cf1b4d7ecea86a07e45725a0/GitPython-3.1.12.tar.gz"
    sha256 "42dbefd8d9e2576c496ed0059f3103dcef7125b9ce16f9d5f9c834aed44a1dac"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/75/fb/2f594e5364f9c986b2c89eb662fc6067292cb3df2b88ae31c939b9138bb9/smmap-3.0.4.tar.gz"
    sha256 "9c98bbd1f9786d22f14b3d4126894d56befb835ec90cef151af566c7e19b5d24"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    def prepare_repo(uri, local_head)
      system "git", "init"
      system "git", "remote", "add", "origin", uri
      system "git", "fetch", "origin"
      system "git", "checkout", local_head
      system "git", "reset", "--hard"
      system "git", "checkout", "-b", "master"
      system "git", "branch", "--set-upstream-to=origin/master", "master"
    end

    first_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "first" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", first_head_start)
    end

    second_head_start = "f863d5ca9e39e524e8c222428e14625a5053ed2b"
    mkdir "second" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-cask-games.git", second_head_start)
    end

    system bin/"gitup", "first", "second"

    first_head = Utils.git_head(testpath/"first")
    refute_equal first_head, first_head_start

    second_head = Utils.git_head(testpath/"second")
    refute_equal second_head, second_head_start

    third_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "third" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", third_head_start)
    end

    system bin/"gitup", "--add", "third"

    system bin/"gitup"
    third_head = Utils.git_head(testpath/"third")
    refute_equal third_head, third_head_start

    assert_match %r{#{Dir.pwd}/third}, `#{bin}/gitup --list`.strip

    system bin/"gitup", "--delete", "#{Dir.pwd}/third"
  end
end
