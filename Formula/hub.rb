class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.5.tar.gz"
  sha256 "653cb1efed6d39348f630472b68f79b11704f52fdd7aebd82f7a6dbe18c32c59"
  revision 1

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e0ba7030f69c32617cb985dc07eb02152af0ca97536f213038a078b08e33cf2" => :el_capitan
    sha256 "d069a6a449e43010b5180951b862dc4fd430f6ac9293afc18e1d5cce2d98cb9d" => :yosemite
    sha256 "481ed5b14848cd0cbea654e807eeefeda9f7a6978e2544ab49951ef195aeab69" => :mavericks
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  # Fix "Error creating pull request: Created (HTTP 201)"
  # Opened PR 12 Aug 2016: "CreatePullRequest: expect HTTP 201"
  patch do
    url "https://github.com/github/hub/pull/1228.patch"
    sha256 "82f81155fcb436f207883fd0aabef98546bfa0032b3cd63a66eb624442091548"
  end

  def install
    system "script/build", "-o", "hub"
    bin.install "hub"
    man1.install Dir["man/*"]

    if build.with? "completions"
      bash_completion.install "etc/hub.bash_completion.sh"
      zsh_completion.install "etc/hub.zsh_completion" => "_hub"
    end
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/hub ls-files").strip
  end
end
