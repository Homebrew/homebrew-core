class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "https://openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.4.tar.gz"
  sha256 "a8ebbb6f3d92d07e671500587472518cfc87cb79b9a654a5a8abb2d0eb298016"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/FST/FstDownload"
    regex(/href=.*?openfst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c254806ca055fb4a6133b87c7e8d4ad12316281db0b1ce6c0bbf89e7bc59554"
    sha256 cellar: :any,                 arm64_sequoia: "170b2d2c3a8567af3feec554218bc4c8d6d62b2e8f04395e3fc3b5ef8451c846"
    sha256 cellar: :any,                 arm64_sonoma:  "9d437bc3a9cb1661b816b8ab6c7ab8f4d18303cf67e23ecd4285142c03a8f537"
    sha256 cellar: :any,                 arm64_ventura: "b6111a87dbce7299b5bb7616c4886df0df105ff5f5dbad107312953017092fcc"
    sha256 cellar: :any,                 sonoma:        "053608b3f203e6d338d124bd7efbb4abaccaef09541710ada922e714e924ed45"
    sha256 cellar: :any,                 ventura:       "ee4d24be7b6490cbe241d86a4df0e3c9274e175ee9bac9ae5df410de8f0dff00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fba19fbd00295bf3f4c8980c5f1cc7c7848eae6d22d7bc02432836f299f17db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e99e7fd868352d8f1956c5e2721ec89dbe064c39018c680d19e2ddaab3bb787"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-fsts",
                          "--enable-compress",
                          "--enable-grm",
                          "--enable-special",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"text.fst").write <<~EOS
      0 1 a x .5
      0 1 b y 1.5
      1 2 c z 2.5
      2 3.5
    EOS

    (testpath/"isyms.txt").write <<~EOS
      <eps> 0
      a 1
      b 2
      c 3
    EOS

    (testpath/"osyms.txt").write <<~EOS
      <eps> 0
      x 1
      y 2
      z 3
    EOS

    system bin/"fstcompile", "--isymbols=isyms.txt", "--osymbols=osyms.txt", "text.fst", "binary.fst"
    assert_path_exists testpath/"binary.fst"
  end
end
