class Analog < Formula
  desc "Logfile analyzer"
  # Last known good original homepage: https://web.archive.org/web/20140822104703/analog.cx/
  homepage "https://tracker.debian.org/pkg/analog"
  url "https://deb.debian.org/debian/pool/main/a/analog/analog_6.0.orig.tar.gz"
  sha256 "31c0e2bedd0968f9d4657db233b20427d8c497be98194daf19d6f859d7f6fcca"
  revision 1

  bottle do
    rebuild 2
    sha256 arm64_monterey: "6d650cbaa55b49f8407641609a7a385a012e808c92e29535cc01546844e76d35"
    sha256 arm64_big_sur:  "4e6a37c076a833e41ac3387ad7cfe104574a1cede5c424e4ac1655b931e415eb"
    sha256 monterey:       "f0b0a7945d2f7205da0de2133424e1e89927ccd424b05e83b1ec528c5dd4b98c"
    sha256 big_sur:        "e91c6eb8aac2f1abb025c8dd4d8834235bb5ee142983b0f35e26e1a540ce5a47"
    sha256 catalina:       "bcfaa87aae0fd274b47855a212ee5d806a37f6c677582b0f2ddaf2f71fd29cb0"
    sha256 mojave:         "87337ab3f0049004b3b6e5bdcdb70c07f4a4cd457a917b7ec99e48650e3d560d"
    sha256 high_sierra:    "d6cf3bcc19b376b693cc27ccd0ebeafb80a05c783405a13ed0d24abd07368cb2"
    sha256 sierra:         "cb8cb25d3050dc3a08445987739c43b5fd7dad7a798342fb7538c016930a9978"
    sha256 el_capitan:     "097f11e7f53078e6b248e38fc326cded49b08cdbe75ab61e20ab7b2a6e770256"
    sha256 yosemite:       "f2f29ea2dcbb9e0576c72f009d8814b0c7f84efd49d6f005085c876c85fd29b9"
    sha256 x86_64_linux:   "b1a70d6f217d54e77750a4cc79076b875d4ee8b864385a88eca04abbd4e15304"
  end

  depends_on "gd"
  depends_on "jpeg"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    args = [
      "CC=#{ENV.cc}",
      "CFLAGS=#{ENV.cflags}",
      %Q(DEFS='-DLANGDIR="#{pkgshare}/lang/"' -DHAVE_ZLIB),
      "LIBS=-lz -lm",
    ]
    args << if OS.mac?
      "OS=OSX"
    else
      "OS=UNIX"
    end
    system "make", *args

    bin.install "analog"
    pkgshare.install "examples", "how-to", "images", "lang"
    pkgshare.install "analog.cfg" => "analog.cfg-dist"
    (pkgshare/"examples").install "logfile.log"
    man1.install "analog.man" => "analog.1"
  end

  test do
    output = pipe_output("#{bin}/analog #{pkgshare}/examples/logfile.log")
    assert_match "(United Kingdom)", output
  end
end
