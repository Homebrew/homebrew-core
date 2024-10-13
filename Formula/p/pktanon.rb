class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.kit.edu/software/pktanon/index.html"
  url "https://www.tm.kit.edu/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  license "GPL-2.0-or-later"
  revision 4

  # The regex below matches development versions, as a stable version isn't yet
  # available. If stable versions appear in the future, we should modify the
  # regex to omit development versions (i.e., remove `(?:[._-]dev)?`).
  livecheck do
    url "https://www.tm.kit.edu/software/pktanon/download/index.html"
    regex(/href=.*?pktanon[._-]v?(\d+(?:\.\d+)+)(?:[._-]dev)?\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "06412917c998e86cc7ba70272699a10fa2d2d76d662f36640ef9b0bb773ba761"
    sha256 cellar: :any,                 arm64_sonoma:   "088984576d203e28d79b142e1d68996c88ff972f6959ad088ac80ad32780cada"
    sha256 cellar: :any,                 arm64_ventura:  "a5f1e1035cdccf58ccdffb87c9baabf590f87f97da5bbf0334b0e598d97c102c"
    sha256 cellar: :any,                 arm64_monterey: "596c0bd371e83b51b8fd5f5f0f992086db13622078e45193da2749178c280b93"
    sha256 cellar: :any,                 sonoma:         "3285f89136d1a40bd4b87a425d09f995d4dd4e8969ac998dbaf0b2cfcf10a21f"
    sha256 cellar: :any,                 ventura:        "48192cac76e6cee2ed1926e1a1f2cf6d337c4d756accbc5635ae2f04c4c24018"
    sha256 cellar: :any,                 monterey:       "a9954ab7b82d9ce6e8aab1a95e8e47ef8979e53a03584b556b3c02fa61056b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d55f5090da3b26eaa66152213636fafabf34e6e1b22103cd430976f544504311"
  end

  depends_on "boost" => :build
  depends_on "xerces-c"

  fails_with gcc: "5"

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
