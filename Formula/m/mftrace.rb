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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8aa73e0e6273a2581098b5663dd4740b43a199e768aeedb71bfda4d9c6238479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a906b08512e28d71e50c76bb84b53db1c71d2f43c957e00e38db6c1e9f2dfee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ae8504b1637da59af9f36632ede565a793746d717beafe22bd14f8899230beb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f64689a0d6f61dfa34a97cea05389342fe6de596f6fb36d3f848410b459b16"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a053eb653951c8bf3ecf4539526a7798d894558a30eb91b32761669e3f61df7"
    sha256 cellar: :any_skip_relocation, ventura:        "7aa7e6d90841ad5db57dbcb179ce8602e368034585748330ff20971a29b5c27f"
    sha256 cellar: :any_skip_relocation, monterey:       "86f9134f95fd1b9ecdafe9744bb005f1b6ea12b4daf429b11683ecec0f1f167a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "410afadfc63167456f16b734a9cd0add724b6f7b37c6657e91fe709dee20976d"
  end

  head do
    url "https://github.com/hanwen/mftrace.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python@3.12"
  depends_on "t1utils"

  # Fixed in https://github.com/hanwen/mftrace/pull/14
  resource "manpage" do
    url "https://github.com/hanwen/mftrace/raw/release/1.2.20/gf2pbm.1"
    sha256 "f2a7234cba5f59237e3cc1f67e395046b381a012456d4e6e9963673cf35d46fb"
  end

  def install
    ENV["PYTHON"] = which("python3.12")
    buildpath.install resource("manpage") if build.stable?
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mftrace", "--version"
  end
end
