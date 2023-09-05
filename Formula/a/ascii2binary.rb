class Ascii2binary < Formula
  desc "Converting Text to Binary and Back"
  homepage "https://billposer.org/Software/a2b.html"
  url "https://www.billposer.org/Software/Downloads/ascii2binary-2.14.tar.gz"
  sha256 "addc332b2bdc503de573bfc1876290cf976811aae28498a5c9b902a3c06835a9"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ascii2binary[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab0651840367c796ed21eeceb7b6299338c7b0b42fe2fad395f3494da144470d"
    sha256 cellar: :any,                 arm64_monterey: "f0c93f44f94301da7726208ebff6c51c83b751827518a92c7347c0312bafabcc"
    sha256 cellar: :any,                 arm64_big_sur:  "c205cd2ae106cbbd23999f85812a51bbd0c6453caa761be24082cec7c721fc7f"
    sha256 cellar: :any,                 ventura:        "ea844e5cb1c4dd10ee070ed633f9052cd6762addc0f556ad4433a97ead7f4be5"
    sha256 cellar: :any,                 monterey:       "3a8a279dfc5c852ab3fa081cd61eeb49ced7a94f3b3fb5fa0b9b747211cb2b51"
    sha256 cellar: :any,                 big_sur:        "8b85d75f6bdcf06c7ab2cd68f6f276532aeed3b258dfa7c370c913a5cf1e4e70"
    sha256 cellar: :any,                 catalina:       "7ad654dc498763cb63634191cb9c9c697604faa88fc41d51060df1bb6c0e42ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4b9cc5fe32d49bbb8e0b8acd72396dbbd8fde547777f441b0deab8be17ac57"
  end

  depends_on "gettext"

  def install
    gettext = Formula["gettext"]
    ENV.append "CFLAGS", "-I#{gettext.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib}"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--disable-dependency-tracking"

    system "make", "install"
    man1.install "ascii2binary.1", "binary2ascii.1"
  end

  test do
    binary = pipe_output("#{bin}/ascii2binary -t ui", "42")
    ascii = pipe_output("#{bin}/binary2ascii -t ui", binary).strip
    assert_equal "42", ascii
  end
end
