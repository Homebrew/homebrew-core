class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.3e.tar.gz"
  version "4.3e"
  sha256 "43363cb968c57925f402117ff8ec4b47189e2747b02350805a34fa617d9f618a"
  revision 1

  bottle do
    sha256 "d034117c6d060275241be0e0e1043782a04f8dd30f14bea3c7d26a6a7e6feb35" => :mojave
    sha256 "3945eb3bc733cb230df566c7649aaeb06e8e79e287c5d233d1623a75e9d482c4" => :high_sierra
    sha256 "de439ab15ec2e1854e9c2596438ca395f6678176fe7a9062afdf86afb40f1bee" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gmp"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man1}
      --infodir=#{info}
      --customgc=yes
      --os-macosx
      --native=yes
      --disable-alsa
      --disable-mpg123
      --disable-flac
      --disable-srfi27
      --jvm=yes
    ]

    system "./configure", *args

    # bigloo seems to either miss installing these dependencies, or maybe
    # do it out of order with where they're used.
    cd "libunistring" do
      system "make", "install"
    end
    cd "pcre" do
      system "make", "install"
    end

    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<~EOS
      (display "Hello World!")
      (newline)
      (exit)
    EOS
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program)
  end
end
