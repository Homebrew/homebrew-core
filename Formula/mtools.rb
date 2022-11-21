class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.42.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.42.tar.gz"
  sha256 "1a481268d08bde3f896ec078c44f2bf7f3d643508b2df555a4be851de9aa0ee2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "678340e3220a8ab8719c709ff19803759b802815d005502307da28c7d38562f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de3e1968dd24cfd977443a8a96933f13b327877d2bfa01857267a992f5171be2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cadf0db06ec4248aa59832010726930ebb4829f33b2eeacaa91d7905fbac4d6"
    sha256 cellar: :any_skip_relocation, ventura:        "ff837538d988f9b98f1d58f6a56848493a7697da6d13c5bc2e35e21ae4c89d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "99fe30ef130b5af0ae8681a517f61f11a75665ec6b67db6b0465f4dcf2a46b4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c008f7e562169e11e46ff067707abf200f92091b754b5efb2cf9110002df7abe"
    sha256 cellar: :any_skip_relocation, catalina:       "9ae16d592ffce07adcebc91088202e503ea989a27103b136bb693973a235b109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef4a8dd72d835cc01ce36b09c11bcc3fe29152b979bd5b54bb9692731b6a71b6"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end
