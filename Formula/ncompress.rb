class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v4.2.4.4.tar.gz"
  sha256 "2670439935e7639c3a767087da99810e45bc3997d0638b3094396043571e5aec"
  head "https://github.com/vapier/ncompress"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad84ee31b1b9754d6894dd869b910e3cdfdbe3b744b682f3c71e3296ec60d720" => :sierra
    sha256 "3a7c2e54a18fa87b3f570ba46c72ebe8a6f251032b5d76f295b07c7b0daf6a89" => :el_capitan
    sha256 "9d0989b5010fb3399f6ef7656c39ddc2b434c07fa25e730500443206760d6c70" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    Pathname.new("hello").write "Hello, world!"
    system "#{bin}/compress", "-f", "hello"
    assert_match "Hello, world!", shell_output("#{bin}/compress -cd hello.Z")
  end
end
