class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.21.tar.bz2"
  sha256 "520481c9908d999f8f7546103b78ff9b11f41d25b0938f0a22f10aaa48beef2b"

  bottle do
    sha256 "ff913d0dbbc0e8119de20ed1d73a62271a6c5f0641a9ba330cf10b4e6cfd6512" => :high_sierra
    sha256 "7865396f80f4fe6281ad50b7df4795e5e81999607bb743a0ba0edfbfc8795435" => :sierra
    sha256 "d3d582eec427706ee1134652ce42cdc65f8e16f32f7f46206ca66d5f9a6b9c4d" => :el_capitan
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "libexif" => :recommended

  def install
    args = []
    args << "exif=1" if build.with? "libexif"
    system "make", "PREFIX=#{prefix}", *args
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
