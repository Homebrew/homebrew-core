class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat37_src.tar.gz"
  version "3.7"
  sha256 "65b28cede94442d9b38cd8a9c5faf3d96c7dd81110398cb2825d3a5a7394ef41"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "40d2d3c516684f4f5d84b188df3f38fadaac62a9e7364dd59f3e32f25ca0e988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41a8357957061027fa117db6f182fbd2ed1963882a2c58fee34df499bffdd42b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ada862573506f31365c089f07ddcad78f9b9584a867439de6dfa32064d070833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bef2001e18fe6aeaff008f15a22409507985bf7c6f87f818e83a43c4047552d"
    sha256 cellar: :any_skip_relocation, sonoma:         "67de472ddbf884bbd3a2d9025470bb0f6739bef146ccaefac16b52145437992c"
    sha256 cellar: :any_skip_relocation, ventura:        "3737e45b985ab3d8c531a25cfbd6b34a2391070d9204f98acb452c1e41cf3f88"
    sha256 cellar: :any_skip_relocation, monterey:       "f986ad40642357958593818df9ca9d5f4437213c9ff9e245e4ba0f226c139ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d2248d9720aefca12a6c9e8b86fb8999e644688f5564ceb6828b2f0d9e104f"
  end

  def install
    makefile = if OS.mac?
      "Makefile.mac64"
    else
      ENV.cxx11
      "Makefile.linux64"
    end
    system "make", "-C", "emu", "-f", makefile
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
