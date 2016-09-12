class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.8.tar.gz"
  sha256 "61f67d94d495bdd2f8e7eae3054fab8a5ec8f5d839f27a63dbacc2a4e230d847"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ae441e39a1e21cd385233f9f4222fcb5f61b30c4e77a1cdb638e0dcf5e3f918" => :sierra
    sha256 "55f17ae15b11ebff7ff57a934475f0fd7b9e9cf2619db8a93190575da12f5552" => :el_capitan
    sha256 "d79daee351b63fd6a1280d91f27c9420c7a5f5d15adf5cbb199e75fcecb455fa" => :yosemite
    sha256 "82d6b6d0fb1c26bb3e2057c12cb826ab151c83114dd173c5058566aa5f6eda11" => :mavericks
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
