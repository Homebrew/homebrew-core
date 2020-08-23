class Curseofwar < Formula
  desc "Fast-paced action strategy game"
  homepage "https://a-nikolaev.github.io/curseofwar/"
  url "https://github.com/a-nikolaev/curseofwar/archive/v1.3.0.tar.gz"
  sha256 "2a90204d95a9f29a0e5923f43e65188209dc8be9d9eb93576404e3f79b8a652b"
  license "GPL-3.0"
  head "https://github.com/a-nikolaev/curseofwar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddd5726a8951c2ec18c9f26bbed80d2d22baeef02eb6e1f313d4591f0db7064b" => :catalina
    sha256 "5847323530aec077f4a17d4c4eb78ee0f90499940dbce3608aba6d4f39e3719e" => :mojave
    sha256 "b2a0646e145b7ef8f502b6f544d106c05c90974c0f8972285a5dfa753305eece" => :high_sierra
  end

  def install
    system "make", "VERSION=#{version}"
    bin.install "curseofwar"
    man6.install "curseofwar.6"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/curseofwar -v", 1).chomp
  end
end
