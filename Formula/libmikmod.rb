class Libmikmod < Formula
  desc "Portable sound library"
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.11.1/libmikmod-3.3.11.1.tar.gz"
  sha256 "ad9d64dfc8f83684876419ea7cd4ff4a41d8bcd8c23ef37ecb3a200a16b46d19"

  bottle do
    cellar :any
    sha256 "f7785b9a4f95ff28d55ffd022780ed1cd9bde139b3482cc4f52b862cd9abf247" => :sierra
    sha256 "202b59906b8113d694f9c1e81df7a5f00f8afbc9e66a2b1188674058a64ae206" => :el_capitan
    sha256 "8276808d976d108dd2768cacb5b54bf570ef6662b8855e7d3537e0ffaaeb1a19" => :yosemite
  end

  option "with-debug", "Enable debugging symbols"

  def install
    ENV.O2 if build.with? "debug"

    # macOS has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << "--with-debug" if build.with? "debug"
    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
