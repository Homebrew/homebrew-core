class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.2.1/fdupes-2.2.1.tar.gz"
  sha256 "846bb79ca3f0157856aa93ed50b49217feb68e1b35226193b6bc578be0c5698d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d4923b54b24b67a3e1c01a0e230a7aff23c5be96bc448fa4b819ba961720b2d"
    sha256 cellar: :any,                 arm64_monterey: "4ec16494f0ec45087289875f4f2eb02df77e21ba937f0b5069976241fdd072a1"
    sha256 cellar: :any,                 arm64_big_sur:  "0dfb5e0dee88c277a48187d32892968da7f646efd032e80ea082242377907295"
    sha256 cellar: :any,                 ventura:        "b9ad08ebb908b91bb9b0d3e7b46770dc7afadd948b12fc8cfd3c8f64526db1f5"
    sha256 cellar: :any,                 monterey:       "2e25670f381e0554075a19f280f21c5d5703dae94332514af2ff521be94cda98"
    sha256 cellar: :any,                 big_sur:        "274cf06310fb49f0bc5548cc39a6a6b7a80b595019e4adbd79897dff9b5d9b9a"
    sha256 cellar: :any,                 catalina:       "44b821561c585b3b258120c18524b459813b889b298b0fa99ac21bdb096fe66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4145b2b6b20271a0cf652e2ff650b668154ce5d74cc0e0f48c00369eb7cd56"
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
