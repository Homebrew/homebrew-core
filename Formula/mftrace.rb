class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "https://lilypond.org/mftrace/"
  url "https://lilypond.org/downloads/sources/mftrace/mftrace-1.2.20.tar.gz"
  sha256 "626b7a9945a768c086195ba392632a68d6af5ea24ef525dcd0a4a8b199ea5f6f"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?mftrace[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32fde76ddb6cf67c7811e56a89b45f1740ddff54b677c8e251d1dd56421f3b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8466199e22f9463110acd4599057f136120eefd81d72dd4055a0b09dda48eeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0add7cd815e3752d182eebd26698daa34f99bc7a34a7441edc6f142ed354308"
    sha256 cellar: :any_skip_relocation, ventura:        "eec33fe79864da672e825b96229a093b251502655ad3e00a61bf0dd1942f1ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "6aacf0e9c4cd21ca8abe71c97175b7c3173f9dabc6426c7ec4dc5b4174d56588"
    sha256 cellar: :any_skip_relocation, big_sur:        "39e39a52a9cc3a4d96257cd13b8f70633583102ca73ca5984035ba8ac55a6892"
    sha256 cellar: :any_skip_relocation, catalina:       "2282c664b45e2f701121b9c19059d14642eb0060a9c2973295ba084ba23d7e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd38a84142918b6630ccc5cdffedd471eade106be0d14ce1aab90b9d6d6db90e"
  end

  head do
    url "https://github.com/hanwen/mftrace.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python@3.10"
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
