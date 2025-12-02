class Cuetools < Formula
  desc "Utilities for .cue and .toc files"
  homepage "https://github.com/svend/cuetools"
  url "https://github.com/svend/cuetools/archive/refs/tags/1.4.1.tar.gz"
  sha256 "24a2420f100c69a6539a9feeb4130d19532f9f8a0428a8b9b289c6da761eb107"
  license "GPL-2.0-only"
  head "https://github.com/svend/cuetools.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "608a2dff1244ef93b65739924ea96977afc75052374eb4da5fbb261b48f29413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c25785b0909d4b8ecee88b331ae515e491427126db45af75fbbcc1e94bd287a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d73bc896a9509dae8389723d55e686f56d361f361ce19913092d7e3c294acdd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66cbde230df93cb4cd662c02ff028989e141f6c2cf0e50769a60c4c3bac95c48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b8f56e6ee35c74523629176408833a619c16aba5b81ab260222ed1682f7f938"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6065775e7e6286464caa093613104c747720e1b9ea98f29f71abea5a365ac05"
    sha256 cellar: :any_skip_relocation, sonoma:         "d081a481b29edd36ca8444f1f5a959f825b15326713f4f44445cc203c43726a5"
    sha256 cellar: :any_skip_relocation, ventura:        "812f65a66d659a29eae61ad58c82c9ab2f993fd1ae26b8ec5f6577e07d5983f5"
    sha256 cellar: :any_skip_relocation, monterey:       "65929af8ca94c0c28f16886667d1869924da3bb193ed10797af30f0e43de1744"
    sha256 cellar: :any_skip_relocation, big_sur:        "f649575d3661f08e573a8e72aa3e45580ed8f75f89fbe2409b2684732ab0f0a3"
    sha256 cellar: :any_skip_relocation, catalina:       "dc2d7bfcb8fd048421265da986fdb381007d64c7d2a45d45a53b896bad78bf18"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "333e324eaa7d67aaacbc2eaad315abc19fdc6fe52dd20220cb7fef4f0b73859d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45fd4566e2ce0650ad162fb32f3a12f30523efeded3f6d30612cdd8efca73ffc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # see https://github.com/svend/cuetools/pull/18
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cue").write <<~CUE
      FILE "sampleimage.bin" BINARY
        TRACK 01 MODE1/2352
          INDEX 01 00:00:00
    CUE
    system bin/"cueconvert", testpath/"test.cue", testpath/"test.toc"
    assert_path_exists testpath/"test.toc"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index f54bb92..84ab467 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 AC_INIT([cuetools], [1.4.0], [svend@ciffer.net])
-AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AM_INIT_AUTOMAKE([-Wall -Werror -Wno-extra-portability foreign])
 AC_PROG_CC
 AC_PROG_INSTALL
 AC_PROG_RANLIB
