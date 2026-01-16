class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.7.tar.xz"
  sha256 "afd287aa672c48b8e1a93fdb6c6588453d527510d966822b687f2835f0d986e9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6b63139c74cde388ab6d8ba9cc69e3f7032e0ede0c1b28b1dfaffe2b13ca5938"
    sha256 arm64_sequoia: "ba45e6d2e5017ce3b2ced758f30a3f24245a35a9ea263e8b2f998af20a1c9760"
    sha256 arm64_sonoma:  "7fe07dc926617c8ec07a21eb8866db22e2bf7843b2de16350e91bcf1d76e9e70"
    sha256 sonoma:        "43ac3c3067fc0e34653685a9fdff9b4eb2a2009169c9492a69aeaca3bd14c821"
    sha256 arm64_linux:   "8e79ce32c8a55823dc6929db1fd42469540e85cab59bb16caf2945c0aa1c3c9d"
    sha256 x86_64_linux:  "d931e71ce0ccf7538366f47b3459e938bc3a5c9a1de5a75fa24106749d1a7f95"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "ncurses"

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "./configure", "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system bin/"nano", "--version"

    # Skip test on Intel macOS due to CI failures
    return if OS.mac? && Hardware::CPU.intel?

    PTY.spawn(bin/"nano", "test.txt") do |r, w, _pid|
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0018" # Ctrl+X
      sleep 1
      w.write "y"      # Confirm save
      sleep 1
      w.write "\r"     # Enter to confirm filename
      sleep 1
      OS.mac? && r.read
    end

    assert_match "test data", (testpath/"test.txt").read
  end
end
