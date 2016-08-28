class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"

  bottle do
    cellar :any
    sha256 "7aed9d36c90ca46bc044fd78e5b9f61e7b0b8f83c819b107ecd52012c5e0f047" => :el_capitan
    sha256 "de336efe0f9746aec3c4fd68db3961c5e9e3e7ad93d361bb9e15b4d68b683c5a" => :yosemite
    sha256 "ec248f5797e1a94fb05f67d15223c5de6fc2997d5f653ad65aeb4b370f898f95" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gsl"
  depends_on "glib"
  depends_on :python => :optional
  depends_on "pygobject" if build.with? "python"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--enable-python-bindings" if build.with? "python"
    system "./configure", *args
    system "make", "install"
  end
end
