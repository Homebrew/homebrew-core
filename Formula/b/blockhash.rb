class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3c48af7bdb1f673b2f3c9f8c0bfa9107a7019b54ac3b4e30964bc0707debdd3a"
  license "MIT"
  revision 2
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "201a828ccfe083e1e70df637d67a7e71b4cfc59a5096915b01ada733e1a11d7d"
    sha256 cellar: :any,                 arm64_sonoma:   "251e7a3a447adf80f2d2756a929382245415ea57396dc23c88b5712acedee62e"
    sha256 cellar: :any,                 arm64_ventura:  "038b0670df91404e906fe197916916c68f61a82d852c106c4efe264462cddb07"
    sha256 cellar: :any,                 arm64_monterey: "2d4b09f8db1db75fdcb79bc4876fd33a1663ef2180deb6fe6c8e0c44a68ce27b"
    sha256 cellar: :any,                 arm64_big_sur:  "47c642decba6f1acb6f94b7a644a0e9cc104b90434028ae80232b2d038942ba1"
    sha256 cellar: :any,                 sonoma:         "a6ba8893f041e115d6510d1fd40acc8b4e4898fefc9b1e15bc03ecfb67bc9151"
    sha256 cellar: :any,                 ventura:        "2e0f529baa77937899b2dbd71739ad986a90f9ea6b8f753a8ebb6cae7974c7fd"
    sha256 cellar: :any,                 monterey:       "54fac760e9b22d8681a67f80c9258f1301ae9ab86f06079cf43242414a018bcd"
    sha256 cellar: :any,                 big_sur:        "c7681e033e02989c06dcb2fc500e56ad8a60700216d6f5191c87972b5ea2489d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "153b687979543a521e1152a77c02c73d8b1b876cacab1524f08269df217e2df6"
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick"

  uses_from_macos "python" => :build

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    # pkg-config adds -fopenmp flag during configuring
    # This fails the build on system clang, and OpenMP is not used in blockhash
    inreplace "build/c4che/_cache.py", "-fopenmp", ""
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    resource("homebrew-testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
