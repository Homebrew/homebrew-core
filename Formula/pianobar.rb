class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git"

  stable do
    url "https://6xq.net/pianobar/pianobar-2017.08.30.tar.bz2"
    sha256 "ec14db6cf1a7dbc1d8190b5ca0d256021e970587bcdaeb23904d4bca71a04674"

    # Remove for > 2017.08.30
    # Upstream commit from 17 Apr 2018: "Remove deprecated header avfiltergraph.h"
    patch do
      url "https://github.com/PromyLOPh/pianobar/commit/38b16f9957a7bad74e337100b497ffc04ceb9a54.diff?full_index=1"
      sha256 "521152c24d63242062dc48c28b7489a540ebcd8a98b0c99c29408e0b58c587fa"
    end
  end

  bottle do
    cellar :any
    sha256 "83394d5085f9495f23901731eaf17565589cea6234332d27dad02dbb8ddf330c" => :high_sierra
    sha256 "a3d622b4b55cbfbb3d1f939e9fe500aa42d8e4a1edb66278288723d2bf41a659" => :sierra
    sha256 "32db2239d66180b79ea149b5e0121f8b70ccf4fc3d0c13b76218efd3924d4f8d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "json-c"
  depends_on "ffmpeg"

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end
end
