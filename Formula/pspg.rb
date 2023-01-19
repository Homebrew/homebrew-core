class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.2.tar.gz"
  sha256 "84b2f75fdd02598e467c56a3a7de1791aec37bbcb07da8c91a62be1cb8b7aadd"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9949dd4ec668593b0038f5fbcf9a72a6f68bc88995dee4da355857bbcda7658"
    sha256 cellar: :any,                 arm64_monterey: "314819192df2f349a263fdead1cb21847037b33afbbb01d7a26d6b13799b552e"
    sha256 cellar: :any,                 arm64_big_sur:  "3d9bba9582ef3b823ad37c6444ebdd1e40fbe24569075ee8bee96c00d30a9e90"
    sha256 cellar: :any,                 ventura:        "1de93dfeded4d2715eb30d9769ef25fdc8f5c7543fb24526e64615ef04266706"
    sha256 cellar: :any,                 monterey:       "949e8986d61e0e0234c7b714ff848f002b3e20a56cf657a3178e47dcca11aae0"
    sha256 cellar: :any,                 big_sur:        "535d1a2438d4b2fba76dc6bec660ba8193dff48be04a5179fe8d2667b4db5cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bdb06fc685d8baca861cbb155bc291c36beb7d3108b32b994c36b25341fefec"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
