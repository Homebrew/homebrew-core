class Dsocks < Formula
  desc "SOCKS client wrapper for *BSD/macOS"
  homepage "https://monkey.org/~dugsong/dsocks/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/dsocks/dsocks-1.8.tar.gz"
  sha256 "2b57fb487633f6d8b002f7fe1755480ae864c5e854e88b619329d9f51c980f1d"
  license "BSD-2-Clause"
  head "https://github.com/dugsong/dsocks.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "601324838005b2686e67ea99328ad71a5f59250b8c329bbc9a0861d1bbfe0dbe"
    sha256 cellar: :any,                 arm64_sequoia:  "9130e47d1bfae90594a9127a2aa63144b9101563558cf1fa704205c874bf23a5"
    sha256 cellar: :any,                 arm64_sonoma:   "07f6f3c0e0ca8250eccd463a6cc728bf5ba0400727232ccbfada5137087085b6"
    sha256 cellar: :any,                 arm64_ventura:  "5c950e6047a1c85b8107378594822cc7e563a87a7bce9547f3b21617362b8245"
    sha256 cellar: :any,                 arm64_monterey: "932d52fc3ff219d56ce68f2214e06b045d5a38d8b8fe517269a7664d9757568a"
    sha256 cellar: :any,                 arm64_big_sur:  "3df61628945a370c1d969c68a53c42bfb095b506ee6a9eae81711ef20c215238"
    sha256 cellar: :any,                 sonoma:         "74cb6a7094f9ab35ddce847203400b4093dc7a0251ce2c0a519f106eaa1a500c"
    sha256 cellar: :any,                 ventura:        "a4d3e2c8193a67fbde79cdba6c28e0d3c603ea8d5a1f1e5a0705af588fa6f256"
    sha256 cellar: :any,                 monterey:       "bb719116a3f8703f022416836e22808dd5ed1b7974d5a36e853764324d663d0e"
    sha256 cellar: :any,                 big_sur:        "56c7d9bf70295a5c41fc439d16c9c905b4eb40dcc2d6a4d27513efd5cc48979a"
    sha256 cellar: :any,                 catalina:       "d675be1f5c6a31c1fbb20dd8c521a638edca6ecfe13a6bb1f8db84b35a01178d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "142addcc7f101ad923269f0b046f358c50e856423d0ba9adeab86f1f657af6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e5fda6bf8552306949f8571bd51a080870219a6f43f73464a1e92326e6e7ff"
  end

  def install
    system ENV.cc, "-fPIC", "-shared", "-o", shared_library("libdsocks"), "dsocks.c",
                   "atomicio.c", "-lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install shared_library("libdsocks")
    bin.install "dsocks.sh"
  end
end
