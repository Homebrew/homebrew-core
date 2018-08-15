class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.4.4.tar.gz"
  sha256 "ab28cda96a43712e27322464010925caece4d231fa15bbd0926e284116b03a99"

  bottle do
    sha256 "6007a1c3479f73914e2341b752427e6a000de5370179371a3c5331ec5e855461" => :high_sierra
    sha256 "c2636e4e5080329d6b646b373155266a5c058a5f14a6831cca7c57066d157661" => :sierra
    sha256 "0955736ae167f904bf08473713910ef4ecc95bb487776eb4e1f6db3e11085431" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
