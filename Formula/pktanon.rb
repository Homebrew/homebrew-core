class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  license "GPL-2.0-or-later"
  revision 4

  # The regex below matches development versions, as a stable version isn't yet
  # available. If stable versions appear in the future, we should modify the
  # regex to omit development versions (i.e., remove `(?:[._-]dev)?`).
  livecheck do
    url "https://www.tm.uka.de/software/pktanon/download/index.html"
    regex(/href=.*?pktanon[._-]v?(\d+(?:\.\d+)+)(?:[._-]dev)?\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "786ffbd6c138d0d1f9ecac03e3638a681b539d81c3d03a98ec18c397937a748e"
    sha256 cellar: :any,                 arm64_monterey: "7bce2aef63a3a786500090ec47feeee781f3ea815c1e290138df41a8d44663f6"
    sha256 cellar: :any,                 arm64_big_sur:  "36905bed56897e7151f048047b5696c36d7cdc2ef8ee310568daf29022e9b2ec"
    sha256 cellar: :any,                 ventura:        "63600257c413f301e3f82c2714c8e1e4daae6e05f07f8f51a3ccced2522d77b8"
    sha256 cellar: :any,                 monterey:       "077c0faf136fd7ec5a0d5596fb84e720d376dfce83d85563ceb74bfcae48f61e"
    sha256 cellar: :any,                 big_sur:        "1cb761204f479937cb389f2754dbb1bd4227a6759fa4b9c9ca3d8011e3fbcd22"
    sha256 cellar: :any,                 catalina:       "52761b594fd6ade559756d25174e5ce53fa6db21db5d1795e750a58c6ef85b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a53776fa3c529c82d9f1ae3725b9a5a82fe6ff9c35cae2133859f7245f161e"
  end

  depends_on "boost"
  depends_on "xerces-c"

  fails_with gcc: "5"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %Q(#include "Timer.h"\r\n),
      %Q(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pktanon", "--version"
  end
end
