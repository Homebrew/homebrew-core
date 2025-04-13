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
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "097fa4cc166f51d4033415a651817207d3a5734ef50237969b84f5a8fc6ddfb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9415613e99216e1174b5e962761cef44084c8e9ef41208673b31e44d55879828"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e639eb620cac19e786da74b7a387f742f23837823bb2dee341e42a5b6df751d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "69753e27a76317dfa0c872ac7a7a90e8c0849c39fae13a1cc677a1b1ded7c26f"
    sha256 cellar: :any_skip_relocation, ventura:       "406e8d33e1825be811ad65d5b77d9f9538011238b3811b9cda2f40bdf50a3b80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e079fcd7a317dfd7018ce822dbaef57907cbe203c96230df05adfba693fbe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138d79020d6a8942911908b01c237b00dc0847d9d8e4a506818db60e54aef44c"
  end

  head do
    url "https://github.com/hanwen/mftrace.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python@3.13"
  depends_on "t1utils"

  # Fixed in https://github.com/hanwen/mftrace/pull/14
  resource "manpage" do
    url "https://github.com/hanwen/mftrace/raw/release/1.2.20/gf2pbm.1"
    sha256 "f2a7234cba5f59237e3cc1f67e395046b381a012456d4e6e9963673cf35d46fb"
  end

  def install
    ENV["PYTHON"] = which("python3.13")
    buildpath.install resource("manpage") if build.stable?
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mftrace", "--version"
  end
end
