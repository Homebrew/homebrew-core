class Lrzsz < Formula
  desc "Tools for zmodem/xmodem/ymodem file transfer"
  homepage "https://www.ohse.de/uwe/software/lrzsz.html"
  url "https://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz"
  sha256 "c28b36b14bddb014d9e9c97c52459852f97bd405f89113f30bee45ed92728ff1"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?lrzsz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d775c475daffed711d6092a64ff59d2b70a4190d2a38a0d0546c745ab3f47be3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6009c2f7058febf2aff37e82a6b2c3fd7d553948facff288e10b7c9b681b75dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "427b498d1c8853fdcd90bc96572f5f622c7c17b229101382fa235aad6e95fd40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e482e9c98553b62eb062bc44af16fe368ab8d58eea5802619e6f88c75204bbeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d103f9f4cfdf4f19a69c5d47b80ab8bfcfa2e19ead1c187a25d89e49b70120a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af1dde66f4c633e9fdfa3b5108987626f79d3f8e3c5efc80b55f29c4720cef04"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e142df2d83321df66df998711fd74b4e69394064e11851506cefe77acdeb7b5"
    sha256 cellar: :any_skip_relocation, ventura:        "4136c5c9b7272acc2d6bc646e25b100eac45357b83ad6c12dada8307ae138a8d"
    sha256 cellar: :any_skip_relocation, monterey:       "7cdda25c0645a005a715e99bfd591c575425cb8eb4667b4c51aadaab097154dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8030d909e2c336ada4563b4bb7e052f8ab382e3ea1325599bcf52b14a35fcbd0"
    sha256 cellar: :any_skip_relocation, catalina:       "e8d2badf80013a07d43d89b2a2e2f99c2feb3abd2b6eeb579a52f01b39a9dd49"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "93671f7f8b73b5f063b8ac4aecfa47e907635368904089aa1ed55bfa693dc7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f5db00a0b2cdc4920a809f4aa1f352eb6962980270d15e65dd418a99ac61ab2"
  end

  conflicts_with "lrzip", because: "both install `lrz` binaries"

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
    url "https://raw.githubusercontent.com/macports/macports-ports/ed7e89dfbf638daf6f217274e7a366ebc3c7e34e/comms/lrzsz/files/patch-zglobal.h.diff"
    sha256 "16c2097ceb2c5c9a6c4872aa9f903b57b557b428765d0f981579206c68f927b9"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/1dc9c770d34f9f235e5ed619d9284e521d4bbeb8/comms/lrzsz/files/implicit.patch"
    sha256 "215bcf3d21f8cb310c1a3de9a35184effe7f10d2e6ab4d91a65cfb436ddc5c4e"
  end

  # Patch CVE-2018-10195.
  # https://bugzilla.novell.com/show_bug.cgi?id=1090051
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/2319730/comms/lrzsz/files/patch-CVE-2018-10195.diff"
    sha256 "97f8ac95ebe4068250e18836ab5ad44f067ead90f8389d593d2dd8659a630099"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

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
