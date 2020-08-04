class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.9.tar.gz"
  sha256 "caa4b3dd314e065c6f387b2713f7603673e39a8a0b1a76f96ef6c9a5b845da0f"
  license "ISC"

  bottle do
    cellar :any
    sha256 "ff5a04ebf89d246f641855d36290a38810d18308dbc37377e15e0ae008137685" => :catalina
    sha256 "25fc3bf106e6df3ad1e32d074faa895ebe22611b3af25df32efd399d88f1a094" => :mojave
    sha256 "6bcd186e46f2cb55b9c07e6c4562caa2b3c16c5cd10c67c4294356a592e5c01b" => :high_sierra
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
