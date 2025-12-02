class B2sum < Formula
  desc "BLAKE2 b2sum reference binary"
  homepage "https://github.com/BLAKE2/BLAKE2"
  url "https://github.com/BLAKE2/BLAKE2/archive/refs/tags/20190724.tar.gz"
  sha256 "7f2c72859d462d604ab3c9b568c03e97b50a4052092205ad18733d254070ddc2"
  license any_of: ["CC0-1.0", "OpenSSL", "Apache-2.0"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2c13b1572d5c05d0c824ffa7cc06a385d7a99c7e03ab695701a4a95964677abd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78ff50b93a895f7bb3344a5469d54dbbd55066e27903a0411be5c8406d9bf896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f950ffbb7054c14bc13c5308966a2eb461557103b96f43d446781b9353887a78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9fb48197fac700a466ea1628a59ed6a5b6a9690977659bb31c9fe31bf5fce63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64c2c7d38639bafcf1ae62c5c1b4d6226dc57fcf7cff654c676d97be597b3d40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c75a1aaf69f5bdec9706848244f7baaa4c17066d99e791ad9d007a483d1671"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7e35223790e6b251dbad52a84e5cd3c1bbfe774039afdfcbc6d40a7537126df"
    sha256 cellar: :any_skip_relocation, ventura:        "b68e4c748c44e8087d61da723e3402dd9e6506b038695e6bbd447333bb69503f"
    sha256 cellar: :any_skip_relocation, monterey:       "70a311dd99f685268a3bcef834c4373d8506fafcd17de9a15fbe9fb68f2fcaed"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd4870a8a8ea954c5f8b45addfd4ee6ccac3f69f058a54be623ea271b3b4be78"
    sha256 cellar: :any_skip_relocation, catalina:       "339b959eb5c2cbc8c26a39022937ea27b7911ff1c9f0611c3f2ac1595f5b0e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "045bcf83cd9918310902dcf419763b59bfa86c1cce653d2469a760e3cff05219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3de701be2858013ed380a477ce9b911db189812984990cd420b9f6d5df7a82bd"
  end

  conflicts_with "coreutils", because: "both install `b2sum` binaries"

  def install
    cd "b2sum" do
      inreplace "makefile", "../sse", "../neon" if Hardware::CPU.arm?
      system "make", "NO_OPENMP=1"
      system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
    end
  end

  test do
    checksum = "ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d1" \
               "7d87c5392aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923  -"
    assert_equal checksum, pipe_output("#{bin}/b2sum -", "abc", 0).chomp
  end
end
