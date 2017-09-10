class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.1.2.tar.gz"
  sha256 "f7e26dc232c177336474a14487771037a8fb32e311f5ccd076a00dc04b6d7b7a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "18f79fcd64996479f193b4872e3c5a641bf9550c4fd3447c1b663b0f38a53edf" => :sierra
    sha256 "daa7dc3537fba0f8403a8a03af895b6a7f6914c2ec75fd36c7f4e9e67e5295a3" => :el_capitan
    sha256 "dbb1193f7e0d36d2980653715e205a54d41ea4d0bffa53b39b27e637636de4b9" => :yosemite
    sha256 "17c6b22921cb4ea64009a8d076f95b6da70c42e3f65e0d49bfc36bcf3e1372e9" => :mavericks
    sha256 "bf67c05965270e3fd2ce47a3c3832ee9119f75ca06087978041277dd1425f72a" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-examples"
    system "make"
    system "make", "install"
  end
end
