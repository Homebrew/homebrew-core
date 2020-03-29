class Analog < Formula
  desc "Logfile analyzer"
  # Last known good original homepage: https://web.archive.org/web/20140822104703/analog.cx/
  homepage "https://tracker.debian.org/pkg/analog"
  url "https://deb.debian.org/debian/pool/main/a/analog/analog_6.0.orig.tar.gz"
  sha256 "31c0e2bedd0968f9d4657db233b20427d8c497be98194daf19d6f859d7f6fcca"
  revision 1

  bottle do
    rebuild 2
    sha256 "bcfaa87aae0fd274b47855a212ee5d806a37f6c677582b0f2ddaf2f71fd29cb0" => :catalina
    sha256 "87337ab3f0049004b3b6e5bdcdb70c07f4a4cd457a917b7ec99e48650e3d560d" => :mojave
    sha256 "d6cf3bcc19b376b693cc27ccd0ebeafb80a05c783405a13ed0d24abd07368cb2" => :high_sierra
    sha256 "cb8cb25d3050dc3a08445987739c43b5fd7dad7a798342fb7538c016930a9978" => :sierra
    sha256 "097f11e7f53078e6b248e38fc326cded49b08cdbe75ab61e20ab7b2a6e770256" => :el_capitan
    sha256 "f2f29ea2dcbb9e0576c72f009d8814b0c7f84efd49d6f005085c876c85fd29b9" => :yosemite
    sha256 "c9ca1f30d5b71b7653ecbbdb4ad8d9e81e41b2e33a9dc2c8e0a92af7cd48007d" => :mavericks
  end

  depends_on "gd"
  depends_on "jpeg"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DEFS='-DLANGDIR=\"#{pkgshare}/lang/\"' -DHAVE_ZLIB",
                   "LIBS=-lz",
                   "OS=OSX"

    bin.install "analog"
    pkgshare.install "examples", "how-to", "images", "lang"
    pkgshare.install "analog.cfg" => "analog.cfg-dist"
    (pkgshare/"examples").install "logfile.log"
    man1.install "analog.man" => "analog.1"
  end

  test do
    output = pipe_output("#{bin}/analog #{pkgshare}/examples/logfile.log")
    assert_match /(United Kingdom)/, output
  end
end
