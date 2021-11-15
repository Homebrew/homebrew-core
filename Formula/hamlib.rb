class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.3.1/hamlib-4.3.1.tar.gz"
  sha256 "3437386dfdd2314f108cf35f1527b20d784256b76633d216a50de94f4045a730"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e2cc38c67064a6c70498d89f4c1c69c9edf05d929d00f5d1cc4eceefa12aa457"
    sha256 cellar: :any,                 arm64_big_sur:  "7f36daff76d09ccb8e658a35f7af8680eaa26b9fef126ba34fd310ecb0d62867"
    sha256 cellar: :any,                 monterey:       "f0452a508ab61b5631b317495e1ae5b0d3ccae9c9d3a393d918fe50d4a78075f"
    sha256 cellar: :any,                 big_sur:        "ef3297063fedaf4707a39d20413bf686e0c6385514f922e257f91b2799b2edc0"
    sha256 cellar: :any,                 catalina:       "766097ea2db2ce5a04c1cdd00bdb25498c90bc7c7d11231510719df3970ec72c"
    sha256 cellar: :any,                 mojave:         "60053d4a8c3c84f6c25e67b0adc734ff1e6e04ed6b82303070c4960f3f31c45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26df356384a03eb37c3218637e4f7ade77b102ad6f4c5bce880cf67f665f65a4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
