class Gitup < Formula
  desc "Update multiple git repositories at once"
  homepage "https://github.com/earwig/git-repo-updater"
  url "https://github.com/earwig/git-repo-updater.git",
    :revision => "4d1989609a1fa3743e07275170e1c19e8a838c0f",
    :tag => "v0.4"

  bottle do
    cellar :any_skip_relocation
    sha256 "df3840c9daaac7b04edc11f479258351f9748f868ec02f1df5547139c5df9cf2" => :sierra
    sha256 "9b372d519ff6ad0544a94c61b827321de1efec9049340a24263358ff83e83163" => :el_capitan
    sha256 "808c74bfc5b026f85ad97bba46c30c39ab244cfa1033579a4607867ae3cd72b8" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "smmap2" do
    url "https://pypi.python.org/packages/83/ce/e5b3aee7ca420b0ab24d4fcc2aa577f7aa6ea7e9306fafceabee3e8e4703/smmap2-2.0.1.tar.gz"
    sha256 "5c9fd3ac4a30b85d041a8bd3779e16aa704a161991e74b9a46692bc368e68752"
  end

  resource "gitdb2" do
    url "https://pypi.python.org/packages/5c/bb/ab74c6914e3b570ab2e960fda17a01aec93474426eecd3b34751ba1c3b38/gitdb2-2.0.0.tar.gz"
    sha256 "b9f3209b401b8b4da5f94966c9c17650e66b7474ee5cd2dde5d983d1fba3ab66"
  end

  resource "GitPython" do
    url "https://pypi.python.org/packages/21/13/8d0981cee1c5b9dd7fa9f836ed7c304891686f300572c03a49e52c07c04c/GitPython-2.1.1.tar.gz"
    sha256 "e96f8e953cf9fee0a7599fc587667591328760b6341a0081ef311a942fc96204"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[colorama smmap2 gitdb2 GitPython].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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

    first_head = `cd first ; git rev-parse HEAD`.split.first
    assert_not_equal first_head, first_head_start

    second_head = `cd second ; git rev-parse HEAD`.split.first
    assert_not_equal second_head, second_head_start

    third_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "third" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", third_head_start)
    end

    system bin/"gitup", "--add", "third"

    system bin/"gitup"
    third_head = `cd third ; git rev-parse HEAD`.split.first
    assert_not_equal third_head, third_head_start

    assert_match %r{#{Dir.pwd}/third}, `#{bin}/gitup --list`.strip

    system bin/"gitup", "--delete", "#{Dir.pwd}/third"
  end
end
