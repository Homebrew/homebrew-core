class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v4.2.4.6.tar.gz"
  sha256 "fb7b6a00060bd4c6e35ba4cc96a5ca7e78c193e6267487dd53376d80e061836b"
  head "https://github.com/vapier/ncompress.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bcfb58a177f7d7c4faa678708cf3dc03d8d57b51502c52d07003204585651dc" => :catalina
    sha256 "ee109f0c632bb97ab6dd85f8f73c526b36becc9e30e003fcc67f32e09d4e9d5b" => :mojave
    sha256 "3f58c3e47a34c1720a0e082c242ca9f57c75a56121b8a79bcf6f2d4a1303c6e8" => :high_sierra
    sha256 "4d9132c7f2ec9386eaab7d6cd740d6cb23438321a64cfce213d622ed6a70464d" => :sierra
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
