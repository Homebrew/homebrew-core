class GitMultipush < Formula
  desc "Push a branch to multiple remotes in one command"
  homepage "https://github.com/gavinbeatty/git-multipush"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/git-multipush/git-multipush-2.3.tar.bz2"
  sha256 "1f3b51e84310673045c3240048b44dd415a8a70568f365b6b48e7970afdafb67"
  head "https://github.com/gavinbeatty/git-multipush.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81d0a4bc4808ab5a31b043640c2ec861cbe6a5fead1a76eda0ffa7bff8ae6158" => :sierra
    sha256 "dab6c9480077541aff39c6ba5b27a91bbc557faedd713178e9f6e8ea7daa5371" => :el_capitan
    sha256 "83355d6549e7cf7d4a9d037cc44895487bb97019e5b810b42266af458302ce7d" => :yosemite
    sha256 "cc6bb7672b79860ae50c06633c28913b5fadb25e2815c5b3e432d4039746f16c" => :mavericks
  end

  devel do
    url "https://github.com/gavinbeatty/git-multipush/archive/git-multipush-v2.4.rc2.tar.gz"
    sha256 "999d9304f322c1b97d150c96be64ecde30980f97eaaa9d66f365b8b11894c46d"
    version "2.4.rc2"
  end

  depends_on "asciidoc" => :build

  def install
    system "make" if build.head?
    # Devel tarballs don't have versions marked, maybe due to GitHub release process
    # https://github.com/gavinbeatty/git-multipush/issues/1
    (buildpath/"release").write "VERSION = #{version}" if build.devel?
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # git-multipush will error even on --version if not in a repo
    system "git", "init"
    assert_match version.to_s, shell_output("#{bin}/git-multipush --version")
  end
end
