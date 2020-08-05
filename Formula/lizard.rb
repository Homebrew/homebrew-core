class Lizard < Formula
  desc "Efficient compressor with very fast decompression"
  homepage "https://github.com/inikep/lizard"
  url "https://github.com/inikep/lizard/archive/v2.0.tar.gz"
  sha256 "85456b7274c9f0e477ff8e3f06dbc2f8ee8619d737a73c730c8a1adacb45f6da"

  bottle do
    cellar :any
    sha256 "93f8a82b125ca4b0548d3a890a3cada1c5724aea95df42b7b224cd83191558fc" => :catalina
    sha256 "adce9d789c2391a96697128d39f103fa0a23b3e462b7e7a2d22346ceeab74925" => :mojave
    sha256 "c3266fb61fb88de0d7a9f3fb2ce53e3ca2708278c7c7064b2b61a4abf138708d" => :high_sierra
    sha256 "928e2fce0d64f3a5c960684ddca781073cdd285fd5f00f61c05675d5cb617366" => :sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    cd "examples" do
      system "make"
      (pkgshare/"tests").install "ringBufferHC", "ringBuffer", "lineCompress", "doubleBuffer"
    end
  end

  test do
    (testpath/"tests/test.txt").write <<~EOS
      Homebrew is a free and open-source software package management system that simplifies the installation
      of software on Apple's macOS operating system and Linux. The name means building software on your Mac
      depending on taste. Originally written by Max Howell, the package manager has gained popularity in the
      Ruby on Rails community and earned praise for its extensibility. Homebrew has been recommended for its
      ease of use as well as its integration into the command line. Homebrew is a non-profit project member
      of the Software Freedom Conservancy, and is run entirely by unpaid volunteers.
    EOS

    cp_r pkgshare/"tests", testpath
    cd "tests" do
      system "./ringBufferHC", "./test.txt"
      system "./ringBuffer", "./test.txt"
      system "./lineCompress", "./test.txt"
      system "./doubleBuffer", "./test.txt"
    end
  end
end
