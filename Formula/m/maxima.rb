class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.50.0-source/maxima-5.50.0.tar.gz"
  sha256 "0bc4b5e11fe153ef20b24a3a816b668ece5378cc738fa24ca426b62fd6d8fc37"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0ec2940c17339f4ff345191b0aeaaf9525fe7e3b827dbf24e0ef13535e30a5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b19374d8548e113fe2f9c25c5cbad275757433b9432f1ca23dc12fa87d000ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efa9cd9d6b11d10dc5799d2f8748163a69c7e84efcd7ec9458b8b5bed23077a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1564dd71befd32013698b55e0ee463d0f70fbfe5c4218f16ef7756ea21250f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b67d8cd195ee1fcc912834732e933298e2c356ec25ced3162a404d9859590013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec331f91cab6223b2cbf84d336fb74c8cf375f93a1e10e69e68100ba5a8d851c"
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
