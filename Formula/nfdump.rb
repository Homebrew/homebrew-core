class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.7.1.tar.gz"
  sha256 "b06e0a7cee1dc641f67f404049ecee9b4d0ee1113542798d7df022ed9f2f4609"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "33d314eb90a08878c4927d898921c4e557d2bc0aae178df91718712d10643256"
    sha256 arm64_monterey: "04a337383fd09716347584defd8819acf51095c843b069c71da5f88d48dbc306"
    sha256 arm64_big_sur:  "381c5df4fa3d79a5a83fd92f0f602de69aff600c5362960abc7b395e2a8d6fc0"
    sha256 ventura:        "5b727480768cd59a8934f9fb38be56be4b8a76cc6e8053e07cb39f15109362f9"
    sha256 monterey:       "0b81418475dc2e43da513d46c4468684c35a878473e7fe3f3a54b7f08270a1b8"
    sha256 big_sur:        "6df9332674504139124d53b39ee60e2d137295c83147f4206137472f2de7f5a5"
    sha256 x86_64_linux:   "7c364ac45075497983aa264b557237b4d78311cc845cf13fef190ac7a0044e65"
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
