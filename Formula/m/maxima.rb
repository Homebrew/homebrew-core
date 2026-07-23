class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"
  revision 7

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e61bdaa8d7a049abb2d6e4edb3747be9dd3d875f62591aeb4c78b64333fe2c8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d5708160884e8e990d98140eebb635ee9047f9f1598f32ec78ab1d88a994e0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be51c118cc8874e5971052e7e63aead9232e96c0ce2b7d8b2a9359ed5a34c6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef0cb27c098913566a2d10327d1a51811c918e1e0f8c91bdd0c319f89c61f049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1133c41b3f341c574c651d902211d2ba5e274bd287698ca09ac4829a25f3642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1340166eb5c3d4826a4d41e8624c2b999ede9a399e0f4545adee2e774528aabb"
  end

  depends_on "gawk" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--enable-gettext",
                          "--enable-sbcl",
                          "--with-emacs-prefix=#{elisp}",
                          "--with-sbcl=#{formula_opt_bin("sbcl")}/sbcl",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end
