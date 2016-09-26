class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.2.6.tar.gz"
  sha256 "7e82b7fbfcc698c70f5843bb960dadb8e7bd7ac1d4d2151c9d979372ea850e85"
  revision 3

  bottle do
    sha256 "3e26f2296b1c2eec67b836ea1dc43ad5ca1f0190c6a7949b4d92052e04de79c7" => :sierra
    sha256 "0db07b334c717e0b467d1aae7c664135534c9c122ad75582496e3269a8e4637b" => :el_capitan
    sha256 "b69a2ad8b89b74ceeb52039a6e08f27334e940a682baf81f8270c2a07d28afea" => :yosemite
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "without-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on :perl => "5.14" if MacOS.version <= :mountain_lion

  def install
    # Fix for 'dyld: lazy symbol binding failed: Symbol not found: _clock_gettime' issue
    # Reported 26 Sep 2016 https://github.com/mobile-shell/mosh/issues/807
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
