class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2016.06.02.tar.bz2"
  sha256 "c6efb0d0fe36013c6506dadf3718e8ed9471b7839654c97027e036ed16212559"
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "ebc6851749b5534cd90166b80e991d81a5b3fa8267a88818653b180e3b0ec2b1" => :el_capitan
    sha256 "45d5973c5ad4057afd1db72781765d92e47d769549d5d27020d35969f112275c" => :yosemite
    sha256 "dbe2176170238d4c7ef849a7360120d5d8b0e6873fdc2b028bcf68fda3b37d2f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "json-c"
  depends_on "ffmpeg"

  fails_with :llvm do
    build 2334
    cause "Reports of this not compiling on Xcode 4"
  end

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
