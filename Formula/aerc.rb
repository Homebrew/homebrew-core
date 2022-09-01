class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.11.0.tar.gz"
  sha256 "3d8f3a2800946fce070e3eb02122e77c427a61c670a06337539b3e7f09e57861"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_monterey: "014f876c6ebfb577d561ea4d46b11e1fd682be0833fd633555450d40224c9acb"
    sha256 arm64_big_sur:  "02eaa8629b073f130d86bd6782687f2108b4dbff0fb06eca0915d807e11d1d3c"
    sha256 monterey:       "fbef7f195c660ccef0dd623ec8b2b8e5a55ebaf0f93f2ab0b04f4475a70216fb"
    sha256 big_sur:        "b44760c1cb2e8d1eb90564bb8ae7578b8d8e93f62147100374c0469570879eb8"
    sha256 catalina:       "b07d4a14920b54e5833bccedcd70a28c2145a87ce9bb146fee46b45039993717"
    sha256 x86_64_linux:   "16085d0bebccfbfbf7548537c481f26b415f69b72db190edabf27dc1979d4841"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
