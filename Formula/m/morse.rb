class Morse < Formula
  desc "QSO generator and morse code trainer"
  homepage "http://www.catb.org/~esr/morse/"
  url "https://gitlab.com/esr/morse-classic/-/archive/2.7/morse-classic-2.7.tar.bz2"
  sha256 "b0414150fc61387775656a1e7fbbc423eb24f45da063ea531d3810ed951202d7"
  license "BSD-2-Clause"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63cd5a3269b81c69ab39a3be47d3a76dc0ef9a44f0d41f8bf7e94a109d5108a0"
    sha256 cellar: :any,                 arm64_sequoia: "d459f6db21be6d02be6458429ced954f31c15ce16ea89cea5f533a3a73fe3cab"
    sha256 cellar: :any,                 arm64_sonoma:  "21e0fd265edc7277e0254d951755bc47e020bf9f8e184d9500d63fcb5b7b8818"
    sha256 cellar: :any,                 sonoma:        "519ca305bca624f04b0e42771e335b5d245a21049829de5b1d5677f66d9b6318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4089a0dba0e309fc44a067114a1b6f8dd520ad29ba4052f2c10e21b01be9f1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328a69c6c05be20cf38718ee30eab62aa3dc8a7404c92068bf23f1412e4851ad"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "pulseaudio"

  # Apply Debian patch to open a mono stream to fix "pa_simple_Write failed"
  patch do
    url "https://salsa.debian.org/debian-hamradio-team/morse/-/raw/7acc68ab78dc8b634c0c81dc56fee0634fc9fc3b/debian/patches/04fix-pa_simple_write-with-mono-output.patch"
    sha256 "ae37ff290eba510fd52fe8babbe86c3ab56755b3ad5a9b7f9949b6a899b06288"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Build can fail if morse.1 and QSO.1 run simultaneously
    ENV.deparallelize

    system "make", "all", "DEVICE=PA"
    bin.install %w[morse QSO]
    man1.install %w[morse.1 QSO.1]
  end

  test do
    if OS.mac?
      # Cannot set up pulseaudio on CI runners so just check for error message
      assert_match "Could not initialize audio", shell_output("#{bin}/morse -m brew 2>&1", 1).strip
    else
      assert_equal "-... .-. . .--", shell_output("#{bin}/morse -m brew").strip
    end
  end
end
