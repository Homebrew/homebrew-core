class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.kit.edu/software/pktanon/index.html"
  url "https://www.tm.kit.edu/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  license "GPL-2.0-or-later"
  revision 5

  # The regex below matches development versions, as a stable version isn't yet
  # available. If stable versions appear in the future, we should modify the
  # regex to omit development versions (i.e., remove `(?:[._-]dev)?`).
  livecheck do
    url "https://www.tm.kit.edu/software/pktanon/download/index.html"
    regex(/href=.*?pktanon[._-]v?(\d+(?:\.\d+)+)(?:[._-]dev)?\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d90ddd6a6904fe38ba56eb87fc3b31c29cf19e4f67f3251245cb8ca8aa072c8e"
    sha256 cellar: :any,                 arm64_sequoia: "44134c55be8a09ccfa54203ccf2ce297df8c8a76e4ef3c94040a523c0bf50cda"
    sha256 cellar: :any,                 arm64_sonoma:  "2cbb5ed4c7c0e22a3de3025fe12860026c7b8264a08374c4f662467ab91187f3"
    sha256 cellar: :any,                 arm64_ventura: "0016600c5e396a07b502fe6060b8e83ad0659479a433e4baf7b0d1a3afba27eb"
    sha256 cellar: :any,                 sonoma:        "202a34eac518440e7d191d05e083a66a424ba49e1df4bca38f83175ca6eafab8"
    sha256 cellar: :any,                 ventura:       "af27c678d49a0928c17ee03cb2af56e3997ffa71c53efbb5edb9c2db3bab1491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4977778371998ed8200618874c1897db9733812e2a7aeeafcae134353fd8e88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a169dd1f2a8226cb31c4039f5a34e62c2077d9667da21f4f6c9a23a7198ca852"
  end

  depends_on "boost" => :build
  depends_on "xerces-c"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %Q(#include "Timer.h"\r\n),
                               %Q(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pktanon", "--version"
  end
end
