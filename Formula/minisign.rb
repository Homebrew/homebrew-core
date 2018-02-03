class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.8.tar.gz"
  sha256 "130eb5246076bc7ec42f13495a601382e566bb6733430d40a68de5e43a7f1082"

  bottle do
    cellar :any
    sha256 "a970943a3b17e6ba9550af0eaad04f85323cf3cc48c8c251e8aec5ef313246f0" => :high_sierra
    sha256 "d59b465ca65ca6379891aca251945ca46ac6377439ff46be05881c505d99c14c" => :sierra
    sha256 "f80d1749268802ec6a71e91bd45a7d54e3db4b186ad353b85054e4940427d552" => :el_capitan
  end

  depends_on "libsodium"
  depends_on "cmake" => :build

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
