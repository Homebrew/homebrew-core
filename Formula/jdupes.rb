class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.20.1.tar.gz"
  sha256 "beff2c812e82c9e6154e1a853594c46c60c871a1364452dc852ba3f1d0ab653b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2718e6d037fcd6fb729139ce08e5eaa42ce0a5ade83fb7a335c2d772964638a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cc7eb382f5a1667d1ac84086bb9b115e704fb5fe3f331ec42ac15055e162192"
    sha256 cellar: :any_skip_relocation, catalina:      "3a3ac1f13b64436a5f1958b6e7cb499e30a37516e0c55b5a46dc895a70b98491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e45cd7275ff6c14378f4ff66dd237fce54272994ae9d14cc50d0c5a8b6a8f196"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
