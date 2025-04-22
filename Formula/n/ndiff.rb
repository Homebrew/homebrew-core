class Ndiff < Formula
  desc "Virtual package provided by nmap"
  homepage "https://www.math.utah.edu/~beebe/software/ndiff/"
  url "https://ftp.math.utah.edu/pub/misc/ndiff-2.00.tar.gz"
  sha256 "f2bbd9a2c8ada7f4161b5e76ac5ebf9a2862cab099933167fe604b88f000ec2c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?ndiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a23ac16ac1bda1aa63ff7e64c8a101bc5a1bb1dfda6ee25ad6e6aac1eae3e2b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b4c46a18f21ebab95fba30b75734e9cc3e9e392909961e8901e43624faf2f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "731436f80a687a2e5d2a2d2a53bd338164bbcf828cd01297e14683caf4c93e22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "731436f80a687a2e5d2a2d2a53bd338164bbcf828cd01297e14683caf4c93e22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7c14877b300c9a36d4047b883e773397f819f60718b9e13d17ca4359b317541"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b4c46a18f21ebab95fba30b75734e9cc3e9e392909961e8901e43624faf2f74"
    sha256 cellar: :any_skip_relocation, ventura:        "731436f80a687a2e5d2a2d2a53bd338164bbcf828cd01297e14683caf4c93e22"
    sha256 cellar: :any_skip_relocation, monterey:       "731436f80a687a2e5d2a2d2a53bd338164bbcf828cd01297e14683caf4c93e22"
    sha256 cellar: :any_skip_relocation, big_sur:        "409ac74964648efd98d55c7b07ffcb90066e23b08a50b495b4e43183fd3a9aef"
    sha256 cellar: :any_skip_relocation, catalina:       "0998b523aa16873d2ed4d776d29df511154e941ffba972d7560176c82add4515"
    sha256 cellar: :any_skip_relocation, mojave:         "1849064e29be787191a0e1dba0322ca1f06361cff18127a26a926e5e7c12c79c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e07f1749ab348c33f3918e0278ac4dacbb6aee0553dbb62434a8b59174d20746"
    sha256 cellar: :any_skip_relocation, sierra:         "ed6f753f9fe240486de3b6589350fcc0e7afbe345ae2e01bf6b47e132de9be4e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6faf20ce4c88110019c76cc4253cd65e5743fab7cff109fc8a7d41c8f411012e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c030a5b399fa30e0f1ce974e9900718dead459f3fffd5d856ada54ebc277c204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417d767a85801798bdd56f860a6554abbac5cf980080106ab5767be4c53121ca"
  end

  conflicts_with "cern-ndiff", "nmap", because: "both install `ndiff` binaries"

  def install
    # workaround for newer clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    ENV.deparallelize
    # Install manually as the `install` make target is crufty
    system "./configure", "--prefix=.", "--mandir=."
    mkpath "bin"
    mkpath "man/man1"
    system "make", "install"
    bin.install "bin/ndiff"
    man1.install "man/man1/ndiff.1"
  end

  test do
    system bin/"ndiff", "--help"
  end
end
