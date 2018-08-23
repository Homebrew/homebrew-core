class Lrzsz < Formula
  desc "Tools for zmodem/xmodem/ymodem file transfer"
  homepage "https://www.ohse.de/uwe/software/lrzsz.html"
  url "https://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/lrzsz-0.12.20.tar.gz"
  sha256 "c28b36b14bddb014d9e9c97c52459852f97bd405f89113f30bee45ed92728ff1"
  revision 1

  bottle do
    sha256 "22a62f1fa5fe2efa9f81b0b1ac747b10b47bdf4e3b64c3672a71b87f6a8ae14f" => :mojave
    sha256 "90c283b839ebd3dc24c81192955e8ba697368fb2c2dd641d66ebbf7baf41d0f2" => :high_sierra
    sha256 "1ae883de3fa1c03f926ab1c35c5a8564fc955096ca166a801bfcfdeefa9dc860" => :sierra
    sha256 "578641aa80e798cfea91cd20b1d6f0b6a3190f2656dc81e3ccc24caadcf1c3b2" => :el_capitan
    sha256 "c417cab543224228762023031d93f2b4acfe0f970ed3ea1cc6616893e83cad6b" => :yosemite
    sha256 "2644d211f486bbc5e67094d80454025a53e9dbda37154e9161f6a5908958788c" => :mavericks
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/2319730/comms/lrzsz/files/patch-man-lsz.diff"
    sha256 "71783e1d004661c03a1cdf77d0d76a378332272ea47bf29b1eb4c58cbf050a8d"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/2319730/comms/lrzsz/files/patch-po-Makefile.in.in.diff"
    sha256 "132facaeb102588e16d4ceecca67bc86b5a98b3c0cb6ffec7e7c4549abec574d"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/2319730/comms/lrzsz/files/patch-src-Makefile.in.diff"
    sha256 "51e5b0b9f0575c1dad18774e4a2c3ddf086c8e81c8fb7407a44584cfc18f73f6"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/ed7e89d/comms/lrzsz/files/patch-zglobal.h.diff"
    sha256 "16c2097ceb2c5c9a6c4872aa9f903b57b557b428765d0f981579206c68f927b9"
  end

  # Patch CVE-2018-10195.
  # https://bugzilla.novell.com/show_bug.cgi?id=1090051
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/2319730/comms/lrzsz/files/patch-CVE-2018-10195.diff"
    sha256 "97f8ac95ebe4068250e18836ab5ad44f067ead90f8389d593d2dd8659a630099"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-nls"
    system "make"

    # there's a bug in lrzsz when using custom --prefix
    # must install the binaries manually first
    bin.install "src/lrz", "src/lsz"

    system "make", "install"
    bin.install_symlink "lrz" => "rz", "lsz" => "sz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lrb --help 2>&1")
  end
end
