class Dsocks < Formula
  desc "SOCKS client wrapper for *BSD/macOS"
  homepage "https://monkey.org/~dugsong/dsocks/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/dsocks/dsocks-1.8.tar.gz"
  sha256 "2b57fb487633f6d8b002f7fe1755480ae864c5e854e88b619329d9f51c980f1d"
  license "BSD-2-Clause"
  head "https://github.com/dugsong/dsocks.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "932d52fc3ff219d56ce68f2214e06b045d5a38d8b8fe517269a7664d9757568a"
    sha256 cellar: :any, arm64_big_sur:  "3df61628945a370c1d969c68a53c42bfb095b506ee6a9eae81711ef20c215238"
    sha256 cellar: :any, monterey:       "bb719116a3f8703f022416836e22808dd5ed1b7974d5a36e853764324d663d0e"
    sha256 cellar: :any, big_sur:        "56c7d9bf70295a5c41fc439d16c9c905b4eb40dcc2d6a4d27513efd5cc48979a"
    sha256 cellar: :any, catalina:       "d675be1f5c6a31c1fbb20dd8c521a638edca6ecfe13a6bb1f8db84b35a01178d"
    sha256 cellar: :any, mojave:         "04977648b6805fb7e82c01064872c9a44356cc2b8499adde514aebe1687bfed8"
    sha256 cellar: :any, high_sierra:    "c6f4212b4e925dc0d29b21f96ab244a8a6842ea44b72f3e48036e69d86ac4c93"
    sha256 cellar: :any, sierra:         "896675fab1d6bf50e5ab9512041ab49fcf9af65198d93ec85c0f2c0d801df49d"
    sha256 cellar: :any, el_capitan:     "9b764e48bfe348433382d030a4aa00eefe1afa63b6bcfaab2450101bb429020e"
    sha256 cellar: :any, yosemite:       "d537e7fe450742d499835b2ba76a94df1285162709b7d953530d5814a0f78019"
  end

  def install
    system ENV.cc, ENV.cflags, "-shared", "-o", "libdsocks.dylib", "dsocks.c",
                   "atomicio.c", "-lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install "libdsocks.dylib"
    bin.install "dsocks.sh"
  end
end
