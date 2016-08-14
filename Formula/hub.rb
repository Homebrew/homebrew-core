class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.5.tar.gz"
  sha256 "653cb1efed6d39348f630472b68f79b11704f52fdd7aebd82f7a6dbe18c32c59"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "546ade95cc6351c4e70eeb2ef5ccbcae36d9bd751ca000f313070893a405a819" => :el_capitan
    sha256 "642dfcd6c6cde344a2cf98f820e4d3bf9c95120b2a88508503c674bf8c23eaa7" => :yosemite
    sha256 "576dd3fd69abf000eb1e3eefa64a98a25eed69bef14b372b2de554c9f4b08b3e" => :mavericks
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

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
