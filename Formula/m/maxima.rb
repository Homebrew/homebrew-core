class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.48.1-source/maxima-5.48.1.tar.gz"
  sha256 "b0916b5fb37b6eeaae400083175e68e28f80b9a1ab580c106a05448cf1c496b2"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8963cc60fb8277f3f2eed664491bd87fd09eab7afaec56f2aa712d431e43cc4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3639a5695b25ec783eeecfe3b004d0bbcb80123a71e36264fefd4e8c121fdd55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e7eb978a518cc0f4c8ae10cbdc9d264fdc9cb5073943ec6ea6b8ee299561ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bc578cc410ab3d33d100a3bef596ffda4d9e699573c3ac616f4a9a363dc21bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a8dfb9f06a4bcc9582782bdfead1ecaf9125ea14c01c6bf42674523645f11b"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--enable-gettext",
                          "--enable-sbcl",
                          "--with-emacs-prefix=#{elisp}",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end
