class Bogofilter < Formula
  desc "Mail filter via statistical analysis"
  homepage "https://bogofilter.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bogofilter/bogofilter-stable/bogofilter-1.2.5.tar.xz"
  sha256 "3248a1373bff552c500834adbea4b6caee04224516ae581fb25a4c6a6dee89ea"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]

  livecheck do
    url "https://sourceforge.net/projects/bogofilter/rss?path=/bogofilter-stable"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "52568286a8cb6ce65a146f26233362ec1df94e8d028d6c6d41dd889a31ab3e6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9cdd5e3131e6b0880369ac2070e25880f55225b18eb6750bbcf997ffe7864555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99c59d02b18ed1ef58f8c21ebc774ed67be9c694fc0807702c7e675daaad74da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fea13db3d925728149dcfb2349e1b1d9d720f96805f0302ba60f6896005163b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c8c1bdc849bd6b97a1ef962222e0c0f856da11e2f174eb4d7e9d587d971b0ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "f74ffa505ef0bddb0dd6ee98b6a555fb4db02c0634789c3a29113a0ca01e50c2"
    sha256 cellar: :any_skip_relocation, ventura:        "5177e2c0e637368f36783396144f66a4e4fbd7f4620e4a5a870ee5208feeba5a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ba6d67f7e248ea1d7b89ce21480ba2145c2906f22e6db749f4fe68fe16f0406"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a5402defe7709d89be4e8186a4babc6c90562f7ee88ae84dcaf4fd9f0d3caadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ebd115fee3156d79ae0958b1326c7689e9af5092d5ef3e9adc915cbdff96f3"
  end

  uses_from_macos "sqlite"

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-database=sqlite3",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bogofilter", "--version"
  end
end
