class Ekhtml < Formula
  desc "Forgiving SAX-style HTML parser"
  homepage "https://ekhtml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ekhtml/ekhtml/0.3.2/ekhtml-0.3.2.tar.gz"
  sha256 "1ed1f0166cd56552253cd67abcfa51728ff6b88f39bab742dbf894b2974dc8d6"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ab64bc1bb7447d50ce5f12aa6bb5f97c807c23f4895558c8c13cd8ff6b1de14e"
    sha256 cellar: :any,                 arm64_sequoia:  "89250f587a05bcbbe4c03909b5fc47a6b3717b59370eb15bc06bdd4fc7ceddda"
    sha256 cellar: :any,                 arm64_sonoma:   "a55dabeba03f720c3012f0ab26dedd80104e268d64831ac4eebe29f642d83e0c"
    sha256 cellar: :any,                 arm64_ventura:  "58b661aa5f68e984f1fda1ccf0dd9dd9a9ab0f445c9069d96893d558e441dac8"
    sha256 cellar: :any,                 arm64_monterey: "b438d00a18912a1940d38e03386c8589e62083534e0f72608e7a5824418f8109"
    sha256 cellar: :any,                 arm64_big_sur:  "b8f8bd224e339d7aa4e95a94c23fcb93cae06533927256465c7c7719fef46c76"
    sha256 cellar: :any,                 sonoma:         "075d049a35c03208bf88b4ebdd0326160d598ac105dc0277c733ae1df369bc1c"
    sha256 cellar: :any,                 ventura:        "3d1bdcc582ab80b004131b68622139a924f0dd4c1ee7a8f8fa3284d5736e4222"
    sha256 cellar: :any,                 monterey:       "252e39e34ceaa9454a21a16db39556a06ae13701f31671ec8354c86be76107c0"
    sha256 cellar: :any,                 big_sur:        "238ffdbf0c5a207667215d75c4a05f9b32af2ad6d9f53f256977c56623088d11"
    sha256 cellar: :any,                 catalina:       "6599b50de97ee6aec9788ac0479c2ad25f335213b3bc9bbab0e5a8ae5c142482"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3f2ab2f0d6601017ddf04993f8223350d37b134248701391503ad0914067d902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8841e4eeb677f92be17fbaa26ee2d5d1e2d6ce958eff178fdb4a9fcf33ea1363"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.deparallelize
    # Run autoreconf on macOS to rebuild configure script so that it doesn't try
    # to build with a flat namespace and on Linux to help detect arm64 linux
    system "autoreconf", "--force", "--verbose", "--install"
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
