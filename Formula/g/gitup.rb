class Gitup < Formula
  include Language::Python::Virtualenv

  desc "Update multiple git repositories at once"
  homepage "https://github.com/earwig/git-repo-updater"
  url "https://files.pythonhosted.org/packages/7f/07/4835f8f4de5924b5f38b816c648bde284f0cec9a9ae65bd7e5b7f5867638/gitup-0.5.1.tar.gz"
  sha256 "4f787079cd65d8f60c5842181204635e1b72d3533ae91f0c619624c6b20846dd"
  license "MIT"
  revision 10
  head "https://github.com/earwig/git-repo-updater.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e1d094ec14134e880e5058a182f7788d0f46c06c7976226e16ac48709d5a3061"
  end

  depends_on "python@3.13"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  # Replace `pipes` usage for python 3.13
  patch do
    url "https://github.com/earwig/git-repo-updater/commit/b48c59c37849369174ed3ed1d28086c6f3044625.patch?full_index=1"
    sha256 "054c56ff9ea631776fbd24969c534b470f318fd2707b5b5bd690f43abfa1c3a7"
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
