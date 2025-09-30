class Hexcurse < Formula
  desc "Ncurses-based console hex editor"
  homepage "https://github.com/LonnyGomes/hexcurse"
  url "https://github.com/LonnyGomes/hexcurse/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "f6919e4a824ee354f003f0c42e4c4cef98a93aa7e3aa449caedd13f9a2db5530"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f10104a9d6d5f9afff713da5da01cec5ff1d3adcc51a5184e00bbdeaf7606d1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4a7086e819b1cd96888fbd2026a5367552e1eacd579dd72fa81e275c32939499"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ca7161cf90a9794229c2a7fdee93f2a8ffe0db514ff282e480f199d408fbfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e70c0b58b904bd8b310d02ff2c1b486e75ffab55ffda96cd3627920cdd41d4f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5778ff4ddb2d3d4d18c4150c34d2a73be472c239a81a243dd03f93a494a4fcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5147e2ba447a362995e7b4de49fa9519c7f4f4a72e00396e1e850ebc5e6d6e30"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bccca2082f0cb7ea860c031adb448b3c4c7d1009558f77a3aa1dda10850d348"
    sha256 cellar: :any_skip_relocation, ventura:        "1ae6efc1513df7fccc4ed4e124f76b2a1cee2255503e5c495f0cfa53c61c9d81"
    sha256 cellar: :any_skip_relocation, monterey:       "7af11f5ed0d454f43e40d39f35fb1967414d81f314aa46fbadd556265c0966e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "26bbc403b9590ad6891663edfb0c424c7497755098873e4f5cc95fb7231e259b"
    sha256 cellar: :any_skip_relocation, catalina:       "977632cc06d33a8d2f7f44866a7497dc7f8b8b423869f348827f20811c024935"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dfdd735912fd3c69d3e62a7b71b0e4e453b762e5ad5bc7c6788f19c83e4abb59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a77e765183c6f25ab2334662999e980f9c3ee127394682d3723262e0e80b64a"
  end

  uses_from_macos "ncurses"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `fpIN'; file.o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"hexcurse", "-help"
  end
end
