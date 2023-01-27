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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4db753d66ccd96f7b4272e100d47caa5175111850cc0da364bd452260ef6e31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b471c3ba39bb586dc5dee6d154faabe0ea06f25fca76dbe48a3f11e884e02b12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3507622b6f0bf74932c1104a1eb7f66aaa1ab238e28102f42f93186b2ce6d7d1"
    sha256 cellar: :any_skip_relocation, ventura:        "aaf1973d2c4c5010044951ef5c5743f85b037f654fa6a9a0861137d849fb904c"
    sha256 cellar: :any_skip_relocation, monterey:       "a353610085452f56bb18ddb4b1c3bff457f156a300f912f9d513cfb7fc6c1838"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d1e02e4a47afe92b1862173c57b1bcf52ad3e423f59f554d93779340bd7a2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599c1dba64bc6e49ce1ad3a17f3e85d67d233b8a77d399d9e5b11bdae2bcdef8"
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
