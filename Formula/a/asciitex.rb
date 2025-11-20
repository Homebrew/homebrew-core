class Asciitex < Formula
  desc "Generate ASCII-art representations of mathematical equations"
  homepage "https://asciitex.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz"
  sha256 "abf964818833d8b256815eb107fb0de391d808fe131040fb13005988ff92a48d"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5b71c04bd0a92fe7d693aff5674b9464532b0a6160b918832dcf299354b2adc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d70918544a7191e90ce55d8b2cc02b5602ef6210dc6f0269e9667bdc0fce8a26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "001ef3790d111bdafbaf5ab24d20a2c62c09fe3278a05d8115ec382c91b86a89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f12101117b2b9663ac74cfed4d14daa32fbbbc0fbeba1463063c6a151cdb0040"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99da7eb7e14ae19b86cbb881e662fbc6a67cd26c7aadd4cb038add368f9eeb3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b9cae6e65df9390c4a9a9ab55813fe05e291ca928364350d333f0389042b8d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8db42f4ab42823b6d60176e7ef225cc2d714e6a49c8ac280938300ab78180164"
    sha256 cellar: :any_skip_relocation, ventura:        "72fc542175fc6f213602a22893bdbcb784db02431dc17aba29a2509cc04fbb87"
    sha256 cellar: :any_skip_relocation, monterey:       "5e539d41ca86bb5f239671fec71d66969ffa81380fae782677f7a656f4588cb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d62737e9f19a499f84fb442ebc5d8738c96f44a4aeea9104a71b304a9777e6f"
    sha256 cellar: :any_skip_relocation, catalina:       "4899775d92a5f26e4b8530823593e5819b8578c44a4537c949ee4e0f6f3d5614"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0c58b7bfb137b8905ee389497448200beeaf56f9636938f926aaf7497b9dced9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "630265b0202b14fd9459b9f772f8f2c1518ddf1b5a5baf6f086f693c8054b470"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `SYNTAX_ERR_FLAG'; array.o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--prefix=#{prefix}", "--disable-gtk"
    inreplace "Makefile", "man/asciiTeX_gui.1", ""
    system "make", "install"
    pkgshare.install "EXAMPLES"
  end

  test do
    system bin/"asciiTeX", "-f", "#{pkgshare}/EXAMPLES"
  end
end
