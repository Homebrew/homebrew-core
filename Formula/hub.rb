class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.4.tar.gz"
  sha256 "7951d4a172dfb6a9cbc0cbda4204dd6205eb08213257cce49026377596b43e60"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3835e0649ac7a7d789e168be215f1abbf8b58ecfdeadf3a83f266b6741bf24a" => :el_capitan
    sha256 "ebf7c993b6ad94ed326c7264520914e784e73d1455d7ebcb95832cfe4fd36f08" => :yosemite
    sha256 "1efd17068946428dabe9342bb233dd35ecb02411d7402e69103615b5fe77181b" => :mavericks
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
