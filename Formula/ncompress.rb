class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v4.2.4.6.tar.gz"
  sha256 "fb7b6a00060bd4c6e35ba4cc96a5ca7e78c193e6267487dd53376d80e061836b"
  license "Unlicense"
  head "https://github.com/vapier/ncompress.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cc232677371ee83d7af62598553c028e11071e309d8620818965b94d2a43b9a4" => :catalina
    sha256 "c5d28fad3558616e2347c16a3aa8a353c7c5b0317c175a1b99e5d6e0f6bae736" => :mojave
    sha256 "b1fa7c42647c420dd48849ad9fb0f05da911ef3bec9459f9ba3892de2d05a58b" => :high_sierra
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
