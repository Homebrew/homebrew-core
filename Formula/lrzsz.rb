class Lrzsz < Formula
  desc "Tools for zmodem/xmodem/ymodem file transfer"
  homepage "https://www.ohse.de/uwe/software/lrzsz.html"
  url "https://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/lrzsz-0.12.20.tar.gz"
  sha256 "c28b36b14bddb014d9e9c97c52459852f97bd405f89113f30bee45ed92728ff1"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c828fb5694c30334ccd6dd68da5136e2d6c9d53d2e8ac558ef3ba246a7824ef8" => :mojave
    sha256 "c23cc0b0c9a0a7fae5a2e3d69ba01a7e6d09ad5e5a7d06c76620b72773ffebed" => :high_sierra
    sha256 "997f5b81f84b7814b0f4f78f056404f6c309eba1e62136e5f8ddf4b34d953b59" => :sierra
    sha256 "1d6517842b64582f629f36e469b61ee91563e1ef1a1b1841a8a4634759dcb0f1" => :el_capitan
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
