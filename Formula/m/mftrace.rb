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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d4dbf098949319339b846a75c34f03b67e6b9288be17881dc7a958e79d76000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29733fe05cdd66d2cd8933ea426d6cfb64463151e1b3737e07308c77d8e3d05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6ad6365585dc156c13d18d72590ba208b48291d43d023cd24d9dac509c4fb3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd534c47c1a7b6c0d8ede69c36d0334ea7ce6acb61b9e120cde5ce2a1ecb21e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99a63f01ac23f29dc26b14cd63a5f51bb0cdc489d3a902e3d376ae4c64662d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2f5a4759a519ac0eb0ca66dca1ce9d57d096dcd55855b00c803fa02f9921358"
  end

  head do
    url "https://github.com/hanwen/mftrace.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python@3.14"
  depends_on "t1utils"

  # Fixed in https://github.com/hanwen/mftrace/pull/14
  resource "manpage" do
    url "https://github.com/hanwen/mftrace/raw/release/1.2.20/gf2pbm.1"
    sha256 "f2a7234cba5f59237e3cc1f67e395046b381a012456d4e6e9963673cf35d46fb"
  end

  def install
    ENV["PYTHON"] = which("python3.14")
    buildpath.install resource("manpage") if build.stable?
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mftrace", "--version"
  end
end
