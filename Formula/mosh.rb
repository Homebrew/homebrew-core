class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.2.tar.gz"
  sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"
  revision 4

  bottle do
    sha256 "5e05a95d972b509c0469ca933de7a522b74b049cc0dccfe5cb1aa6db34b54fc4" => :mojave
    sha256 "6cff59a934d2d8fda8f40f59c8ec5d0d2b550617478afa6ad56db20b3bb4e4a8" => :high_sierra
    sha256 "c62e3806458d92a044bd00f5ddf08d6a1d01ee5870f77b67c5527a4a81f44251" => :sierra
    sha256 "f990bb41dcdcc581c531138e235d58c6d83dfc53afe5203f44a0db7e92de4ead" => :el_capitan
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "tmux" => :build if build.bottle?
  depends_on "protobuf"

  needs :cxx11

  def install
    ENV.cxx11

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
