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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "04f82b33a8a3806b57864a4295dc727744275e1d57494803780ea373cadaff54"
    sha256 cellar: :any,                 arm64_sequoia:  "5fa97a3db89565045338e7d0a725a0dfe87995651b8987d271bfb5eeb07e7728"
    sha256 cellar: :any,                 arm64_sonoma:   "fa4789ecc58d9510294d6ceb7e88865abecf9b50237def8dde810cea6a9a8477"
    sha256 cellar: :any,                 arm64_ventura:  "ab0651840367c796ed21eeceb7b6299338c7b0b42fe2fad395f3494da144470d"
    sha256 cellar: :any,                 arm64_monterey: "f0c93f44f94301da7726208ebff6c51c83b751827518a92c7347c0312bafabcc"
    sha256 cellar: :any,                 arm64_big_sur:  "c205cd2ae106cbbd23999f85812a51bbd0c6453caa761be24082cec7c721fc7f"
    sha256 cellar: :any,                 sonoma:         "d9430468703535a3bf50d32fdd39b90b140e493d662e002cdf1a11869b5bfdde"
    sha256 cellar: :any,                 ventura:        "ea844e5cb1c4dd10ee070ed633f9052cd6762addc0f556ad4433a97ead7f4be5"
    sha256 cellar: :any,                 monterey:       "3a8a279dfc5c852ab3fa081cd61eeb49ced7a94f3b3fb5fa0b9b747211cb2b51"
    sha256 cellar: :any,                 big_sur:        "8b85d75f6bdcf06c7ab2cd68f6f276532aeed3b258dfa7c370c913a5cf1e4e70"
    sha256 cellar: :any,                 catalina:       "7ad654dc498763cb63634191cb9c9c697604faa88fc41d51060df1bb6c0e42ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dae63772ba06b7609d29d51fa608f8db00d29703b6c42837098b6629a35ac0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4b9cc5fe32d49bbb8e0b8acd72396dbbd8fde547777f441b0deab8be17ac57"
  end

  on_macos do
    depends_on "gettext"
  end

  def install
    if OS.mac?
      gettext = Formula["gettext"]
      ENV.append "CFLAGS", "-I#{gettext.include}"
      ENV.append "LDFLAGS", "-L#{gettext.lib}"
      ENV.append "LDFLAGS", "-lintl"
    end

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    binary = pipe_output("#{bin}/ascii2binary -t ui", "42", 0)
    ascii = pipe_output("#{bin}/binary2ascii -t ui", binary, 0).strip
    assert_equal "42", ascii
  end
end
