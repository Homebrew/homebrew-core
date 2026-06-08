class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  # The upstream homepage was "https://web.archive.org/web/20160310122517/www.ff.iij4u.or.jp/~nrt/lv/"
  homepage "https://salsa.debian.org/debian/lv"
  url "https://salsa.debian.org/debian/lv/-/archive/debian/4.51-10.1/lv-debian-4.51-10.1.tar.gz"
  version "4.51-10.1"
  sha256 "64c1efb7d66301625d3a46dd4b3abed45942b2686de335860bf24a37b01ea858"
  license "GPL-2.0-or-later"
  head "https://salsa.debian.org/debian/lv.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "ecb4b2ddef16ba003c1bed5ba898b4d7938b86d06b8d47a1a2f10bd1b9e1b34e"
    sha256                               arm64_sequoia: "efaec6f504463810396e09314511c35269bf24a9e032190aff1be242605d3245"
    sha256                               arm64_sonoma:  "3ca1bf0482f72301256a514a9b707981422d9c2307e2561eef693bab87c02697"
    sha256                               sonoma:        "e0400df58db2d0cffa3be9f627cdd7439be8388f4cf15d7d557747fe2b5c6e1a"
    sha256                               arm64_linux:   "f540993311d9f5564f0b2d6b9781927fe862e475ff901748d37eb989f55fb04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51062f445c5a3c2bbdb8573e5a5a58affe8a0629fe10773ec2f1b204dda4873c"
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
