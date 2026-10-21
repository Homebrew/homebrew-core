class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "https://lilypond.org/mftrace/"
  url "https://lilypond.org/downloads/sources/mftrace/mftrace-1.2.20.tar.gz"
  sha256 "626b7a9945a768c086195ba392632a68d6af5ea24ef525dcd0a4a8b199ea5f6f"
  license "GPL-2.0-only"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?mftrace[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da4528de49bddc9a2f4616c55e84eeb18269341af370447d959d0e0f77fed680"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4fe5cceb3c8057226955b07e1d42166e822670ad008611a1accbb3b86afb655c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79b3bb505a769dc684a5ce9b37295481958300d067479b36e0f10aba0517fba3"
    sha256 cellar: :any,                 arm64_linux:       "b1920ccac7d62ed7c4c1b1dd823e01a7b78c58bd968bc015b0edfa94af66364e"
    sha256 cellar: :any,                 x86_64_linux:      "7844372685dd1c42dea454c30c482ac329f5db2ee1b24caad8af4b6ecb5b0736"
  end

  head do
    url "https://github.com/hanwen/mftrace.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python@3.15"
  depends_on "t1utils"

  # Fixed in https://github.com/hanwen/mftrace/pull/14
  resource "manpage" do
    url "https://github.com/hanwen/mftrace/raw/release/1.2.20/gf2pbm.1"
    sha256 "f2a7234cba5f59237e3cc1f67e395046b381a012456d4e6e9963673cf35d46fb"
  end

  def install
    ENV["PYTHON"] = python3
    buildpath.install resource("manpage") if build.stable?
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mftrace", "--version"
  end
end
