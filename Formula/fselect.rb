class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.3.2.tar.gz"
  sha256 "9aef280de65b8ffd91993c6eb6321c8fdec4281f3490b070da832b307f8ded1b"

  bottle do
    sha256 "f766c8896858032abb1d65559ffa4b09b2e508e3de51a570c509abd98aeb7e29" => :high_sierra
    sha256 "dde34dd1ee08a272a40452ee51028fcb06589f0cc817745af811bd2b00707647" => :sierra
    sha256 "4a6ee623a2d226fe63f316dc52ea9f14ed152a2943122ff40a02f93174f1bd77" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/fselect"
  end

  test do
    (testpath/"test.txt").write("")
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
