class Dnstop < Formula
  desc "Console tool to analyze DNS traffic"
  homepage "http://dns.measurement-factory.com/tools/dnstop/index.html"
  url "http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20140915.tar.gz"
  sha256 "b4b03d02005b16e98d923fa79957ea947e3aa6638bb267403102d12290d0c57a"
  license "BSD-3-Clause"

  livecheck do
    url "http://dns.measurement-factory.com/tools/dnstop/src/"
    regex(/href=.*?dnstop[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "46e3c705bd4c7649ab67f2712d623825f0006cb764e844131a654fe057de19ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "feab927b414e7fad8995bfb647c2b019bee68c8aa535b5b9cccdd12e048c81fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa31ea8e4f50e891664b89fa0928c25affda0aff9c1aca5d1333e12e052cb413"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a172c0678ce76e45a73491379633aeb893dad579cbbf89047bf2c1c972332327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e991cd5c68fcbefb7c45ac7b977b3f9e51a719cae0dbead9aa7172dbfebeb3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fba6f2f539b25ef2e918c9600a3027a72188984cad8748f2edd55c59712c414"
    sha256 cellar: :any_skip_relocation, sonoma:         "3476a73413a818b4fecca690a8e176974bc0cb09858d6e478f4dbd77f56f9f35"
    sha256 cellar: :any_skip_relocation, ventura:        "4411393ab2b699d8ecc96e791daf89c1fff67e7c10f2d48d19a8f7550da67ec7"
    sha256 cellar: :any_skip_relocation, monterey:       "717e890e2098e17066d717cdf2c38776838326b4d1f0dfeee6b4e55dbedd607f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c07eca212e72ce354b9e29575efa61f607a9ba43dc07072247f925d331ce7763"
    sha256 cellar: :any_skip_relocation, catalina:       "61522feaa64c92d28044e88366555a6f816366671728d71e286960b83a176417"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "67a05c4b6fd3fd1f3008513be83d42d8d1c93d8b9cea2e747a909a5a9d2bb938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8b4de6f9441442ff6c59476101ebf5fbcf6073882c971556fa566afda211bd"
  end

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "dnstop"
    man8.install "dnstop.8"
  end

  test do
    system bin/"dnstop", "-v"
  end
end
