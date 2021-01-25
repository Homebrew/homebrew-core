class Bcrypt < Formula
  desc "Cross platform file encryption utility using blowfish"
  homepage "https://bcrypt.sourceforge.io/"
  url "https://bcrypt.sourceforge.io/bcrypt-1.1.tar.gz"
  sha256 "b9c1a7c0996a305465135b90123b0c63adbb5fa7c47a24b3f347deb2696d417d"

  livecheck do
    url "http://bcrypt.sourceforge.net/"
    strategy :page_match
    regex(/href=.*?bcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9c3948e719b6b5cb195fc30c8e0fd555c35d9fcea7a5a6c607b094ce2e097f01" => :big_sur
    sha256 "7b3e672ab9055b69dc1c7c5a7d13ad3a9a375f60de85cfcc5268f7eb139edcda" => :arm64_big_sur
    sha256 "132998cb8e196f506666943a94a26927a19899cb1e45ee8eaf65e5ad0ee7ef8d" => :catalina
    sha256 "bb843c3b04f9adf57df1c2d07e30303626eedb0f45695dcaf38d0835ea3e35fd" => :mojave
    sha256 "883a4a97b7275e91cd90ab9d1ca69fa2a3c0db3544a2d77863a37bda16c51667" => :high_sierra
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=-lz"
    bin.install "bcrypt"
    man1.install gzip("bcrypt.1")
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    pipe_output("#{bin}/bcrypt -r test.txt", "12345678\n12345678\n")
    mv "test.txt.bfe", "test.out.txt.bfe"
    pipe_output("#{bin}/bcrypt -r test.out.txt.bfe", "12345678\n")
    assert_equal File.read("test.txt"), File.read("test.out.txt")
  end
end
