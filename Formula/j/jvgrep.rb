class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/refs/tags/v5.8.12.tar.gz"
  sha256 "7e24a6954db1874f226054d1ca2e720945a1c92f9b6aac219e20ed4c3ab6e79c"
  license "MIT"
  head "https://github.com/mattn/jvgrep.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "115262945550f47749bbb3e4a15006ffc60121b5daecaad2778861dc3191643b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09906823a2d2bd6a90b0fcf9881cadfadf72693749f7431c787c910d74fb106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b09906823a2d2bd6a90b0fcf9881cadfadf72693749f7431c787c910d74fb106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b09906823a2d2bd6a90b0fcf9881cadfadf72693749f7431c787c910d74fb106"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf79835ac8078c953f7f86e12bed6dc332e268a22455349531945b2ca3414d1"
    sha256 cellar: :any_skip_relocation, ventura:       "3bf79835ac8078c953f7f86e12bed6dc332e268a22455349531945b2ca3414d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "783f014d41c4fd1ed3dc1ada0024f9b8b62677e05218f2c83535d99b3ce1469e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60b337f4a9d97f4107e04eaa49ca7cdca98cb44a158df7664b55a33724639ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
