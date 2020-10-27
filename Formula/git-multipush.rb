class GitMultipush < Formula
  desc "Push a branch to multiple remotes in one command"
  homepage "https://github.com/gavinbeatty/git-multipush"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/git-multipush/git-multipush-2.3.tar.bz2"
  sha256 "1f3b51e84310673045c3240048b44dd415a8a70568f365b6b48e7970afdafb67"
  license "GPL-3.0"
  head "https://github.com/gavinbeatty/git-multipush.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9de9b128791d8c416076ed738016ffe534ce85bacddf297ab9ce13954dcaff6" => :catalina
    sha256 "8f4c2e7a1aee0db75154c4b21aee1a4bd398a9b889f119e7b86a06b1533b9304" => :mojave
    sha256 "edd99d5ec177bccf061f7424aa595a5515fa5728aec649594f42964cec1f371e" => :high_sierra
    sha256 "81d0a4bc4808ab5a31b043640c2ec861cbe6a5fead1a76eda0ffa7bff8ae6158" => :sierra
    sha256 "dab6c9480077541aff39c6ba5b27a91bbc557faedd713178e9f6e8ea7daa5371" => :el_capitan
    sha256 "83355d6549e7cf7d4a9d037cc44895487bb97019e5b810b42266af458302ce7d" => :yosemite
    sha256 "cc6bb7672b79860ae50c06633c28913b5fadb25e2815c5b3e432d4039746f16c" => :mavericks
  end

  depends_on "asciidoc" => :build

  def install
    system "make" if build.head?
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # git-multipush will error even on --version if not in a repo
    system "git", "init"
    assert_match version.to_s, shell_output("#{bin}/git-multipush --version")
  end
end
