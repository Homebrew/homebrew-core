class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.17.1/fswatch-1.17.1.tar.gz"
  sha256 "c38e341c567f5f16bfa64b72fc48bba5e93873d8572522e670e6f320bbc2122f"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "96cea06f4891e9af44abcd6f30a250c8efebe660104893b7fd80c8f22b2ab569"
    sha256 cellar: :any, arm64_monterey: "b7f5facb15c82b5dc9eb94e8cfaa4857e562609be24fdd716051c35bd2e85e8b"
    sha256 cellar: :any, arm64_big_sur:  "ec08b3bf8f659a864d0c54f022939b45ea647c25769a8ab908f60f28ffbd803c"
    sha256 cellar: :any, ventura:        "570223c980f22c296e4d6fa6e6058e778bb0e74d0dd9745ec49ec3940aeb5863"
    sha256 cellar: :any, monterey:       "6c57d2ea9ff9e425069580bba25c74f5890f454b807f4a94810271909d47283e"
    sha256 cellar: :any, big_sur:        "1da6e45f4051477e02acbf2f3d13a7917b8a80a38ca35d6ac8cbaff780df4651"
    sha256 cellar: :any, catalina:       "c97ee3973b847257ad99f6ffff3c6ba3d33dbf2a333e0bbe289832b7e490f051"
    sha256               x86_64_linux:   "60e3f628f00ace185e22523a1850f0521184e7477263ef69a1a0fcebd8b0f077"
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
