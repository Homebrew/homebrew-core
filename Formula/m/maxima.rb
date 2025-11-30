class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.48.1-source/maxima-5.48.1.tar.gz"
  sha256 "b0916b5fb37b6eeaae400083175e68e28f80b9a1ab580c106a05448cf1c496b2"
  license "GPL-2.0-only"
  revision 4

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7413a88afcfdc054c90ff3f9e1c33d07ce92e37a811b3da3beefaa956453b631"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642afa2412d2595b4b8c5d9aaa4c2bccf17e6a2ce4152fabfb11314235fddca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e91ef3daffd2556df2764c72fb6cc24a82cffacd492195aa82e327661579363c"
    sha256 cellar: :any_skip_relocation, sonoma:        "de6ecb86a38e9ffdfd717fd121ccc92557c2ca5cb7a5d368f5b0b44d482e8640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dff0ae9940639acebc6de0ca6ae46cc83b26e9e8e15753fb4b32d4aa52fcd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e068db669604e391637b7d38fba699a927d62875e1dc79e34ee7f26f0fc4bc70"
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
