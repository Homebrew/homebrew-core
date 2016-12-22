class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows."
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake.git", :revision => "d6e2e09ee7c00d9ed371d0a9b16ca87b6ee417e1"
  version "1.0.0-alpha1"
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
