class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.6.tar.xz"
  sha256 "f7abfbf0eed5f573ab51bd77a458f32d82f9859c55e9689f819d96fe1437a619"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2264d7db63d98eaec400967d883896b658b08c57e2705670a8a44ea82f725745"
    sha256 arm64_sequoia: "0265660b145d8913478ae20cad410afbb1b53f02824e9b816a540a32a9275ba5"
    sha256 arm64_sonoma:  "690585c06379c43c6879f619986c2ac966b3bb7eed6294d164fc6bd9ea6e46fc"
    sha256 arm64_ventura: "055b8c6908ce48cd986fea03e9d3c19de6b5f07f0aab6065ff1fbe8a45f93f75"
    sha256 sonoma:        "e375595d032a3c2c8ce7b83494e0ec5db6f4e825cf71b96d5e88f664c3e708d0"
    sha256 ventura:       "492a5a63d21a3f3a37fee73cd7e43d6a29816522602a49644d2c8ee56acdb8c6"
    sha256 arm64_linux:   "bc3334da17c9fcad12362040488ff76bec0e081b36e19f2feee1451a91f24510"
    sha256 x86_64_linux:  "28111d0754b7a278085b0c6b12867c46933c8ef3d9961f4dc3332eb89edd2821"
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
