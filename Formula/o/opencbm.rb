class Opencbm < Formula
  desc "Provides access to various floppy drive formats"
  homepage "https://spiro.trikaliotis.net/opencbm"
  url "https://github.com/OpenCBM/OpenCBM/archive/refs/tags/v0.4.99.104.tar.gz"
  sha256 "5499cd1143b4a246d6d7e93b94efbdf31fda0269d939d227ee5bcc0406b5056a"
  license "GPL-2.0-only"
  head "https://github.com/OpenCBM/OpenCBM.git", branch: "master"

  livecheck do
    url :homepage
    regex(/<h1[^>]*?>VERSION v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d5e8f6b89063a3de0040990afe6bd3a5e135bf0ed37bf05f51af658af12a58f5"
    sha256 arm64_sequoia: "529ae3225eaf83d45e82682ed1e4a209f92e6998c1c646e24532f9e711a8eea1"
    sha256 arm64_sonoma:  "fe90bccc22f2363fad79f49fa1cc5e844d2bc3c83627a9b7460bc5a07b64877d"
    sha256 arm64_ventura: "d278718401caa82cefb764cad68a547d8e09a2a28622ff012472a0dbaeebbb21"
    sha256 sonoma:        "c3c96a4d11cf6d06933aca2bf0ad4cdbc5d4cd7af512fdc7552bba26ec8e4bdd"
    sha256 ventura:       "90c901874fffef22c717c75d8958109f5b82849c6c1ae5ceac0d2c31bd5595a2"
    sha256 arm64_linux:   "267913de51b9eb95fc170c08943564b0106b90baf067099b415e64c588357c74"
    sha256 x86_64_linux:  "d7258949de49e4b268d2d236217f42982663a39430d534f32fc1dc7b60d2d043"
  end

  # cc65 is only used to build binary blobs included with the programs; it's
  # not necessary in its own right.
  depends_on "cc65" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "ncurses"

  def install
    # This one definitely breaks with parallel build.
    ENV.deparallelize

    args = %W[
      -fLINUX/Makefile
      PREFIX=#{prefix}
      MANDIR=#{man1}
      ETCDIR=#{etc}
      UDEVRULESDIR=#{lib}/udev/rules.d
      LDCONFIG=
    ]

    system "make", *args
    system "make", "install-all", *args
  end

  test do
    system bin/"cbmctrl", "--help"
  end
end
