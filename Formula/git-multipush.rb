class GitMultipush < Formula
  desc "Push a branch to multiple remotes in one command"
  homepage "https://github.com/gavinbeatty/git-multipush"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/git-multipush/git-multipush-2.3.tar.bz2"
  sha256 "1f3b51e84310673045c3240048b44dd415a8a70568f365b6b48e7970afdafb67"
  license "GPL-3.0"
  head "https://github.com/gavinbeatty/git-multipush.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f02c0c3d5c5fd2e7ecb84b057ab23bf5452839b479a5ec47e1e374589efdb38"
    sha256 cellar: :any_skip_relocation, big_sur:       "981bdfe608288a854656563e178db2cdb9e9a9db30381203e0f67bfd38d29e16"
    sha256 cellar: :any_skip_relocation, catalina:      "b9de9b128791d8c416076ed738016ffe534ce85bacddf297ab9ce13954dcaff6"
    sha256 cellar: :any_skip_relocation, mojave:        "8f4c2e7a1aee0db75154c4b21aee1a4bd398a9b889f119e7b86a06b1533b9304"
    sha256 cellar: :any_skip_relocation, high_sierra:   "edd99d5ec177bccf061f7424aa595a5515fa5728aec649594f42964cec1f371e"
    sha256 cellar: :any_skip_relocation, sierra:        "81d0a4bc4808ab5a31b043640c2ec861cbe6a5fead1a76eda0ffa7bff8ae6158"
    sha256 cellar: :any_skip_relocation, el_capitan:    "dab6c9480077541aff39c6ba5b27a91bbc557faedd713178e9f6e8ea7daa5371"
    sha256 cellar: :any_skip_relocation, yosemite:      "83355d6549e7cf7d4a9d037cc44895487bb97019e5b810b42266af458302ce7d"
    sha256 cellar: :any_skip_relocation, all:           "d5c375848d38c5eb1f2e47ad8bf1f43e93ed8ac7f6614de4b586b71a3a2d562e"
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
