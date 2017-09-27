class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.2.tar.gz"
  sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"
  revision 1

  bottle do
    sha256 "50554445ea3bf89878b5a69c42e6ffde2127d84f53dc2da7b2cc80ed1383b560" => :high_sierra
    sha256 "05e337d886666e085bc1a37656aff5e57db14e9aec05f10d65a675637d24b52f" => :sierra
    sha256 "e5c563d94f2fd0ca03545ad11feaf8f7318ec1ec8d03564bebc0a98c2e295fde" => :el_capitan
    sha256 "a59848c0b7e2a9b6cbfdc8579bc6d120e8a184d15d09cbbb6e3c37de8feb002d" => :yosemite
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on "tmux" => :build if build.with?("test") || build.bottle?

  def install
    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
