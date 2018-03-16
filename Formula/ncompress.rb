class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v4.2.4.4.tar.gz"
  sha256 "2670439935e7639c3a767087da99810e45bc3997d0638b3094396043571e5aec"
  head "https://github.com/vapier/ncompress.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a690145266b23c89bc3d9762cc5f632bb15f685171f939108c1eebdda06a57f5" => :high_sierra
    sha256 "631c12b675f730ea3a7a170b214f63b1749fabb2d632ce76d76de4c8706cdf79" => :sierra
    sha256 "a046e625feb4e7dbf26136b6ba949f9883de14674571f2291794daf98106558f" => :el_capitan
    sha256 "613392aa88dbf86d8de3d6355dfeb72753a4040fd8c805907f434a7d1e5e78c4" => :yosemite
  end

  keg_only :provided_by_macos

  def install
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    Pathname.new("hello").write "Hello, world!"
    system "#{bin}/compress", "-f", "hello"
    assert_match "Hello, world!", shell_output("#{bin}/compress -cd hello.Z")
  end
end
