class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v0.9.2/mdbtools-0.9.2.tar.gz"
  sha256 "d4ba2974f9d4f0198fa92c5df178af7f52cdc5e1b545b6d0c9d79cd782fca742"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9053e31cbbc87cb451115fbe2fe039071e85cc05cdee130b1890d44888d9c6e3"
    sha256 cellar: :any, big_sur:       "64736fd8868a154014317e36924e1246091fc788e1b3a037ba14678600ea3034"
    sha256 cellar: :any, catalina:      "b37102d082ed7e84a5251551fa5e84618b118ebaa3224a5ec1d19e043551f4fc"
    sha256 cellar: :any, mojave:        "49918a104b998fd7cd87f164d5d9ff47933e0d7cf3a9fb66214979fdfeedf45e"
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
