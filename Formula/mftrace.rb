class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "https://lilypond.org/mftrace/"
  url "https://lilypond.org/downloads/sources/mftrace/mftrace-1.2.20.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/mftrace-1.2.20.tar.gz"
  sha256 "626b7a9945a768c086195ba392632a68d6af5ea24ef525dcd0a4a8b199ea5f6f"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "882a66ccd5a29f67e0fcefb320fd2e271b367c84c48710a4d979940ad8abc4a4" => :catalina
    sha256 "216a869a5dc6455c8853f7965993eb86d4c310dad2d2e8b343690de91d5d9621" => :mojave
    sha256 "487f07e5aec705b5503b97654dbafce5c4c01c94d733d0c51d241b595bc801cc" => :high_sierra
  end

  head do
    url "https://github.com/hanwen/mftrace.git"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python@3.8"
  depends_on "t1utils"

  # Fixed in https://github.com/hanwen/mftrace/pull/14
  resource "manpage" do
    url "https://github.com/hanwen/mftrace/raw/release/1.2.20/gf2pbm.1"
    sha256 "f2a7234cba5f59237e3cc1f67e395046b381a012456d4e6e9963673cf35d46fb"
  end

  def install
    buildpath.install resource("manpage") if build.stable?
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mftrace", "--version"
  end
end
