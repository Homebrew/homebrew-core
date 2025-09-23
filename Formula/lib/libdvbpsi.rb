class Libdvbpsi < Formula
  desc "Library to decode/generate MPEG TS and DVB PSI tables"
  homepage "https://www.videolan.org/developers/libdvbpsi.html"
  url "https://get.videolan.org/libdvbpsi/1.3.3/libdvbpsi-1.3.3.tar.bz2"
  mirror "https://download.videolan.org/pub/libdvbpsi/1.3.3/libdvbpsi-1.3.3.tar.bz2"
  sha256 "02b5998bcf289cdfbd8757bedd5987e681309b0a25b3ffe6cebae599f7a00112"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/libdvbpsi/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "8ca5d9293581da05648c293b9d1e0b67b1f33263c3fc57023f76822c5e2c2d59"
    sha256 cellar: :any,                 arm64_sequoia:  "cdb91a9f85c8f2f255cc0269d01bff6ccd1952f4895a6d26c6cb26e7e5bcb2f7"
    sha256 cellar: :any,                 arm64_sonoma:   "bdd947f3cb943b06739cc4fa888739f746b859fc2036dbbec873eca70f093014"
    sha256 cellar: :any,                 arm64_ventura:  "1c472e474f03c56fc1e29442555abd1786e3f8310d12d1fbc64442f166e8541b"
    sha256 cellar: :any,                 arm64_monterey: "1bf8f2771e32e8799e111cf03d52d765d29e38b3494856f65c004166accaa1cf"
    sha256 cellar: :any,                 arm64_big_sur:  "d235fec5478322cf04a4ed079073b18ac289548ebd0b31b2aaca8b84fe9987a3"
    sha256 cellar: :any,                 sonoma:         "124e4d0858fbb2df20ef1040309365f1f33e62a8f482054353ac2b8c3ebdac8c"
    sha256 cellar: :any,                 ventura:        "94c15b82989c45ea689079e7dfe8655953d192cc8ed09dcfe3400f04bc561434"
    sha256 cellar: :any,                 monterey:       "c1af0d643851a02a2ed1db53f959abf421321e32ea7f5f74e97edc0ca48db6b6"
    sha256 cellar: :any,                 big_sur:        "6897247fd9cfdd4bc5cfd4db8991b7bb5d1647a6f929bab5642c8e673fe1f317"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e86a18402d7540269883632b6c94336146664323efc4eead6f15f3e12d013f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aff79b57483d77c1d376a230726c33df0e1f322d40b9ab7bba314ae28cfc359"
  end

  head do
    url "https://code.videolan.org/videolan/libdvbpsi.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make", "install"
    pkgshare.install "examples/dump_pids.c"
  end

  test do
    resource "homebrew-sample-ts" do
      url "https://filesamples.com/samples/video/ts/sample_640x360.ts"
      sha256 "64804df9d209528587e44d6ea49b72f74577fbe64334829de4e22f1f45c5074c"
    end

    # Adjust headers to allow the test to build without the upstream source tree
    cp pkgshare/"dump_pids.c", testpath/"test.c"
    inreplace "test.c",
              "#include \"config.h\"\n",
              "#include <inttypes.h>\n"

    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}", "-ldvbpsi", "-o", "test"

    resource("homebrew-sample-ts").stage do
      output = shell_output("#{testpath}/test sample_640x360.ts")

      assert_equal 3440, output.lines.length
      output.lines.each do |line|
        assert_match(/^packet \d+, pid \d+ \(0x\d+\), cc \d+$/, line)
      end
    end
  end
end
