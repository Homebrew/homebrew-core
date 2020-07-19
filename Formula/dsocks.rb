class Dsocks < Formula
  desc "SOCKS client wrapper for *BSD/macOS"
  homepage "https://monkey.org/~dugsong/dsocks/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/dsocks/dsocks-1.8.tar.gz"
  sha256 "2b57fb487633f6d8b002f7fe1755480ae864c5e854e88b619329d9f51c980f1d"
  license "BSD-2-Clause"
  head "https://github.com/dugsong/dsocks.git"

  bottle do
    cellar :any
    sha256 "d675be1f5c6a31c1fbb20dd8c521a638edca6ecfe13a6bb1f8db84b35a01178d" => :catalina
    sha256 "04977648b6805fb7e82c01064872c9a44356cc2b8499adde514aebe1687bfed8" => :mojave
    sha256 "c6f4212b4e925dc0d29b21f96ab244a8a6842ea44b72f3e48036e69d86ac4c93" => :high_sierra
    sha256 "896675fab1d6bf50e5ab9512041ab49fcf9af65198d93ec85c0f2c0d801df49d" => :sierra
    sha256 "9b764e48bfe348433382d030a4aa00eefe1afa63b6bcfaab2450101bb429020e" => :el_capitan
    sha256 "d537e7fe450742d499835b2ba76a94df1285162709b7d953530d5814a0f78019" => :yosemite
    sha256 "419d972f1aba39997ec90a4c8e35c98ecfedbfb63506478e8b406ac04a01e5de" => :mavericks
  end

  def install
    system ENV.cc, ENV.cflags, "-shared", "-o", "libdsocks.dylib", "dsocks.c",
                   "atomicio.c", "-lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install "libdsocks.dylib"
    bin.install "dsocks.sh"
  end
end
