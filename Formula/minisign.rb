class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.8.tar.gz"
  sha256 "130eb5246076bc7ec42f13495a601382e566bb6733430d40a68de5e43a7f1082"

  bottle do
    cellar :any
    sha256 "f4f2ead633dca744121338c3fc79e964348fa6d97d5361267df6d4ecbe9a6643" => :catalina
    sha256 "b2862f35643f396fafff03c76697b2d25b8907bd14b4dc4c31c913b60ab88c82" => :mojave
    sha256 "6826fa79c308cc321871704d79baab4deb71e916c00656c0b6cc656042889103" => :high_sierra
    sha256 "bb3f8c4d58e195960606e1f155775da72ba7c019d9dd72b818ed7d232bf4e22c" => :sierra
    sha256 "2884120953aeac755a39365d5905ece08b90b1bfd9568677cd1ed45046fe8491" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libsodium"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "Hello World!"
    (testpath/"keygen.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/minisign -G
      expect -exact "Please enter a password to protect the secret key."
      expect -exact "\n"
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect -exact "\r
      Password (one more time): "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"keygen.sh"

    system "./keygen.sh"
    assert_predicate testpath/"minisign.pub", :exist?
    assert_predicate testpath/".minisign/minisign.key", :exist?

    (testpath/"signing.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/minisign -Sm homebrew.txt
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"signing.sh"

    system "./signing.sh"
    assert_predicate testpath/"homebrew.txt.minisig", :exist?
  end
end
