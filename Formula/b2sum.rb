class B2sum < Formula
  desc "BLAKE2 b2sum reference binary"
  homepage "https://github.com/BLAKE2/BLAKE2"
  url "https://github.com/BLAKE2/BLAKE2/archive/20190724.tar.gz"
  sha256 "7f2c72859d462d604ab3c9b568c03e97b50a4052092205ad18733d254070ddc2"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "70a311dd99f685268a3bcef834c4373d8506fafcd17de9a15fbe9fb68f2fcaed"
    sha256 cellar: :any_skip_relocation, big_sur:      "fd4870a8a8ea954c5f8b45addfd4ee6ccac3f69f058a54be623ea271b3b4be78"
    sha256 cellar: :any_skip_relocation, catalina:     "339b959eb5c2cbc8c26a39022937ea27b7911ff1c9f0611c3f2ac1595f5b0e50"
    sha256 cellar: :any_skip_relocation, mojave:       "905b975371fd88632649e08f732ff25277cd1fd4b584dbc3e4914bcb08f85cd8"
    sha256 cellar: :any_skip_relocation, high_sierra:  "129dbe4d91bf7843a40399b392b3ddc2448e56c249a45567bd9193e4fb722b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3de701be2858013ed380a477ce9b911db189812984990cd420b9f6d5df7a82bd"
  end

  conflicts_with "coreutils", because: "both install `b2sum` binaries"

  def install
    cd "b2sum" do
      system "make", "NO_OPENMP=1"
      system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
    end
  end

  test do
    checksum = <<~EOS
      ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d17d87c5392
      aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923  -
    EOS
    assert_equal checksum.delete!("\n"),
                 pipe_output("#{bin}/b2sum -", "abc").chomp
  end
end
