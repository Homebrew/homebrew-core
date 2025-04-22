class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://github.com/emikulic/darkstat/archive/refs/tags/3.0.721.tar.gz"
  sha256 "0b405a6c011240f577559d84db22684a6349b25067c3a800df12439783c25494"
  license all_of: ["BSD-4-Clause-UC", "GPL-2.0-only", "GPL-3.0-or-later", "X11"]
  head "https://github.com/emikulic/darkstat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5373a3a8b0c7a8138b1dd756814c5d0f383a530170822c5cec37260145a55bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3e4f63fec4c167ff2ac71b28b5cdb1f163c2e961c4316792355500f96c85671"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97674e5bd9b7f7924b24cff91ae6460327cc250272e9b67ef8d98c27f218f8d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5981250184af819d33927ff9c81ab3249ee0ebe1f30c16fe6fdf59383946b718"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "223b3ec850fc9c5837d28d8484100ede7a06995ab925db15581925247e7ab729"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc560a58e6bb24f515919e503a009f993754111bf15306a580fa399caf133930"
    sha256 cellar: :any_skip_relocation, ventura:        "885d6ca5a12e1faeb072e920dda1bcf214d9ecc9b401ffe207babca7ecc067b1"
    sha256 cellar: :any_skip_relocation, monterey:       "8449dc87a9567d043d9cb0639213e0be3e3a664dcbc9829b7a4fd4fa02de5d68"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7f108870e81eb677b299a42824f4680a7f837614d26af49d6cee24519bb21fc"
    sha256 cellar: :any_skip_relocation, catalina:       "ea01bd86053287a7fce043527aa68ad0dc138d6cdb8e800602947b581687f18c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7b937251ad1b3ab158843ccc5ee02041c54304e852708f908d227bf2fb7a6eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b32d27fc6e9539499c8d1c4ca716f2a489814fce3e71929b676339eb54425d9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  # Patch reported to upstream on 2017-10-08
  # Work around `redefinition of clockid_t` issue on 10.12 SDK or newer
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/442ce4a5/darkstat/clock_gettime.patch"
    sha256 "001b81d417a802f16c5bc4577c3b840799511a79ceedec27fc7ff1273df1018b"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
