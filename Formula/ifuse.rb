class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/1.1.4.tar.gz"
  sha256 "2a00769e8f1d8bad50898b9d00baf12c8ae1cda2d19ff49eaa9bf580e5dbe78c"
  license "LGPL-2.1-or-later"
  head "https://cgit.sukimashita.com/ifuse.git"

  bottle do
    sha256 cellar: :any,                 catalina:     "cdce9fc5dbaf44641743b4a77434d340ae11cb8ed98f17b1a86a5653d2b6e1a2"
    sha256 cellar: :any,                 mojave:       "e14e4f8e0f73324dc662b47f091261f682eddc73961e3d71a07bfeb62826a1f8"
    sha256 cellar: :any,                 high_sierra:  "ff5577f28749cf18671eecd953e96f0c52a06dccf827dcf08e2d64f894dfdd5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec03965eeaecd9443c4b5d20a0b20e6275fed16c084a4e05fe1f6cb01f3f7e42"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on "libplist"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
