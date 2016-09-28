class Porg < Formula
  desc "Source Code Package Organizer"
  homepage "http://porg.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/porg/porg-0.10.tar.gz"
  sha256 "48f8433193f92097824ed7a72c4babafb29dc2ffe60e7df3635664f59f09cedd"

  option "without-grop", "Don't install Grop, which is the graphic interface of porg."

  depends_on "pkg-config" => :build
  depends_on "gtkmm3" if build.with? "grop"

  def install
    args = %W[--disable-silent-rules --prefix=#{prefix}]

    if build.without? "grop"
      args << "--disable-grop"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "porg", "--version"
  end
end
