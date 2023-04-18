class Gitup < Formula
  include Language::Python::Virtualenv

  desc "Update multiple git repositories at once"
  homepage "https://github.com/earwig/git-repo-updater"
  url "https://files.pythonhosted.org/packages/7f/07/4835f8f4de5924b5f38b816c648bde284f0cec9a9ae65bd7e5b7f5867638/gitup-0.5.1.tar.gz"
  sha256 "4f787079cd65d8f60c5842181204635e1b72d3533ae91f0c619624c6b20846dd"
  license "MIT"
  revision 5
  head "https://github.com/earwig/git-repo-updater.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6110fff8fd46bffadb3b59d51a48eec76210962047600d867582004749110e73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2912ddcf3ad3afa21a00a57c61d4cf6e91f399f8ca038883c5e18c34329f5b2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "904c9403ba3d1debd7caae12b2022e8eebb1a0dab75d6d2c7937ec00177bd822"
    sha256 cellar: :any_skip_relocation, ventura:        "cc14ccaf85e55faf029a5cbdbfed3f242bc28054f0578989a5f073355a214807"
    sha256 cellar: :any_skip_relocation, monterey:       "7128646ce0ed24a44a05193e7c6fff6725bf97b5cf76693945e8bc40027aad2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7172cbae00985c0f57a1b89b9f5026bd305455546a5266ba1b8d7c212b0fe3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c09f68a85e5d32050da31f4f8364d930f08cadeb19d2002e9f05d1cd624435"
  end

  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  def install
    virtualenv_install_with_resources
  end

  def prepare_repo(uri, local_head)
    system "git", "init"
    system "git", "remote", "add", "origin", uri
    system "git", "fetch", "origin"
    system "git", "checkout", local_head
    system "git", "reset", "--hard"
    system "git", "checkout", "-b", "master"
    system "git", "branch", "--set-upstream-to=origin/master", "master"
  end

  test do
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
