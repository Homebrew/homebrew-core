class Lazymagit < Formula
  desc "Terminal-native Git interface inspired by Magit"
  homepage "https://github.com/richardrh/lazymagit"
  url "https://github.com/richardrh/lazymagit/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "b62e1ff7c59596ecbc203bd9a4607718a0204eddfb0f2c6b807da68e34bc65f2"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/lazymagit"
  end

  test do
    assert_match "usage: lazymagit", shell_output("#{bin}/lazymagit --help")
  end
end
