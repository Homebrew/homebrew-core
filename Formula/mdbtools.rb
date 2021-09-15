class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v0.9.4/mdbtools-0.9.4.tar.gz"
  sha256 "6b75aa88cb1dc49ea0144be381c8f14b2ae47c945c895656dbebc155cd9ee14b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7e61d1793850007b50e3183e681579a86b0ba9cecd52afbf58fba7468b43159e"
    sha256 cellar: :any,                 big_sur:       "701aa107dbe59e6e1d28436e754e6947be68f3bdd0db248f2e587f0003eda711"
    sha256 cellar: :any,                 catalina:      "0bd9e0b1055dc5fe6c541694f70e778372b2eb6bff62f165380c1d14effc1a76"
    sha256 cellar: :any,                 mojave:        "a65b18abe40ed2e1825e2ecd05dcae546803a2a1f0099e2b0a2d0918a8bd580b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "912565cef4ebae2afa1d3bc0726ac30bc0673a3271843150dd5004b9e0aa772c"
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
