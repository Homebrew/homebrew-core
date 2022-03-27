class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.6.24.tar.gz"
  sha256 "11ea7ecba405d57076c321f6f77491f1c64538062630131c98ac62dc4870545e"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "94d16672b219706f75baa315d47e2c9bde577eca38c3e9eaf95fa40e0dcc82c1"
    sha256 cellar: :any, arm64_big_sur:  "e8cd2e522bebe3e5ca989f2c0c7d490bdb55c278a4e372def868a5711855a348"
    sha256 cellar: :any, monterey:       "799210a49e9a258a26860480ec867cf5969194965bbd4d08df359b8e2cbfd7e3"
    sha256 cellar: :any, big_sur:        "19884a8b8d4e0755a5673c018f92bac5153a4a68910ab7b274fe2e632a8830af"
    sha256 cellar: :any, catalina:       "4d68bef98b73b63f23efd5022bb1c0739b2721de66ffb8fbba25bdfbd050bcc8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--enable-readpcap", "LEXLIB="
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
