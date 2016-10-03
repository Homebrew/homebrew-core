class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.9.tar.gz"
  sha256 "b3cf227e38a34a56e37b7705a60bec258cea52174d8e030b559f74af647a70d6"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82228fb79156537b9649a653391640de922fb223c8147a3fa67bd27d386ffa56" => :sierra
    sha256 "7eb6188c498e61f7df86cf85bb8b5ae43e77dd0ceabdaf669149aca6db6530bb" => :el_capitan
    sha256 "96fd51e0996f9f04d25bce0c4e545989bb170b83f1a47b5725e97050772c6999" => :yosemite
    sha256 "336f670800e322c8bdb38d18c3e9566f63c58009233a4080ce6a25b39c17a372" => :mavericks
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
