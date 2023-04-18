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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcc7091b7e3aab969e797cbb583d8d8349856433c9452c818c1cc338b53537d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b7d41129a1f83e1c9e84ad20e706ebd3d93e6c7b9801bd90e866d0e07d8234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24bae79ec700220fea014de05a63df51c061ecf8817e737c24a00c1fd2b3f6ea"
    sha256 cellar: :any_skip_relocation, ventura:        "dc53be3197cdb6ee63607d4d9d3e94220953e85ba05c5e698156087382d557de"
    sha256 cellar: :any_skip_relocation, monterey:       "bae6d024e848e8f7c7a18f8b6d86359f652b7715daa1a11bcdcb6c4e03b5e0b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "57483c84e1722e4ec6e606c24336a615bd8710c3735bbb1c32e3a3afa64b3b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f198472e3e64f2ce72fc9425338c791110ac33f1cecde0c77f584b0373fd7e"
  end

  head do
    url "https://github.com/hanwen/mftrace.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python@3.11"
  depends_on "t1utils"

  # Fixed in https://github.com/hanwen/mftrace/pull/14
  resource "manpage" do
    url "https://github.com/hanwen/mftrace/raw/release/1.2.20/gf2pbm.1"
    sha256 "f2a7234cba5f59237e3cc1f67e395046b381a012456d4e6e9963673cf35d46fb"
  end

  def install
    ENV["PYTHON"] = which("python3.11")
    buildpath.install resource("manpage") if build.stable?
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mftrace", "--version"
  end
end
