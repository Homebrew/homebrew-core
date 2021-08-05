class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v0.9.4/mdbtools-0.9.4.tar.gz"
  sha256 "6b75aa88cb1dc49ea0144be381c8f14b2ae47c945c895656dbebc155cd9ee14b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b3a5aae0b39902a3065a419de67d3c57516666c6651ff2fdfa13a0cc716d7ea0"
    sha256 cellar: :any,                 big_sur:       "92ff7689be581613ec6dfb68a53246925a65b81f38902d081a15520d4cc7ea12"
    sha256 cellar: :any,                 catalina:      "ac2ef7a275f74d9372cea1a7e0012abdcab67ae4caf6c6aaf1b60d92ced9b3c5"
    sha256 cellar: :any,                 mojave:        "aa0dd1053890f163b19aeb7ca338040762cf2c499f9f629c390e57311a2d4cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0936835475319db278156fd8bbe5acb7538e9957f3c4e997f137e4fbcc2baa71"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-man"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mdb-schema --drop-table test 2>&1", 1)

    expected_output = <<~EOS
      File not found
      Could not open file
    EOS
    assert_match expected_output, output
  end
end
