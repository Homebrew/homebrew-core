class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  # The upstream homepage was "https://web.archive.org/web/20160310122517/www.ff.iij4u.or.jp/~nrt/lv/"
  homepage "https://salsa.debian.org/debian/lv"
  url "https://salsa.debian.org/debian/lv/-/archive/debian/4.51-10/lv-debian-4.51-10.tar.gz"
  sha256 "c935150583df6f2cea596fdd116d82ec634d96e99f2f7e4dc5b7b1a6f638aba1"
  license "GPL-2.0-or-later"
  head "https://salsa.debian.org/debian/lv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "104d96df6f6d0a2d7dea6682973d5b13e7c676e3e919f745dd1f7215b80980a0"
    sha256                               arm64_sequoia: "d8fff4f49ad72ed22fe3b335d3a780a6ecc7e97d14e49d9a0cfdb459ab40fc77"
    sha256                               arm64_sonoma:  "103c91e238509bcb1862409cb3483b12311309b98dc0bccd3cdb485866ca6d73"
    sha256                               arm64_ventura: "aa3867a4900aedf77e796f681676e22fc595dcaa8fb6fb9d20cdecd25f688c0c"
    sha256                               sonoma:        "1d572a28261e7bb59a07d707ce3f28299d297442c09c90735196a08525db2c01"
    sha256                               ventura:       "f737ea5ead2f1e11e7e2830e5acb65c2e2228775298dc855d30c4072cdafe83c"
    sha256                               arm64_linux:   "192fa6eb2d9d0076d20e695110731f03e55633592e090db713ec81a81f2296e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f6669252eb821a07cd2648d0356449e22906673c9abbbbd8c604c98a827b27"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "gzip"
  end

  def install
    File.read("debian/patches/series").each_line do |line|
      line.chomp!
      system "patch", "-p1", "-i", "debian/patches/"+line
    end

    cd "build" do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install "lv"
      bin.install_symlink "lv" => "lgrep"
    end

    man1.install "lv.1"
    (lib/"lv").install "lv.hlp"
  end

  test do
    system bin/"lv", "-V"
  end
end
