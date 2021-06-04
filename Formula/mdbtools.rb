class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v0.9.3/mdbtools-0.9.3.tar.gz"
  sha256 "bf4b297a9985e82bc64c8a620adc00e2e3483371a7d280e81249b294fe0e6619"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e9bd349e7979d818b4b45de5cfc26ca64f357188eb63651560821940df39179b"
    sha256 cellar: :any, big_sur:       "77eae2542ef7523274d698928adaafb36b5cdb46979795139100eb4bf9467e82"
    sha256 cellar: :any, catalina:      "70e32cec43c27bdc76420adf8b6dceedc8f0919ddbbcc7e3f8fa09412a0a403a"
    sha256 cellar: :any, mojave:        "741015282fc3fc0d6694afbaf3c3318e5a024cd4628bd572abf9a6ef649ccc0f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-sql",
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
