class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows."
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake.git", :revision => "3f4a076243d2821ae78bc97aaed0ca47301d0d65", :tag => "1.0.0"
  head "https://github.com/HandBrake/HandBrake.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
