class Lizard < Formula
  desc "Efficient compressor with very fast decompression"
  homepage "https://github.com/inikep/lizard"
  url "https://github.com/inikep/lizard/archive/v1.0.tar.gz"
  sha256 "6f666ed699fc15dc7fdaabfaa55787b40ac251681b50c0d8df017c671a9457e6"
  license all_of: ["BSD-2-Clause", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6fcf6c0c2243f9fa4a9f06ebb9b28c2fcf5aaed5916bc3ab6be36024e3096556"
    sha256 cellar: :any,                 arm64_monterey: "870168a41711bd2dac174484f576c7573b422e9b9a9ba20a4f761b262747966f"
    sha256 cellar: :any,                 arm64_big_sur:  "25adf9383bbad3ab6c4f51e38ea46ebe4fc636cc347c8625b2fbd65e89a3144d"
    sha256 cellar: :any,                 ventura:        "75bd1c568655f58d515f452ee69c5b615e3d65c7f9eadba2581a4df5bd2e7d3c"
    sha256 cellar: :any,                 monterey:       "463d92f46e8fbdd327b99b8322c2dbb24ff2d08635f44a2706665066741658d9"
    sha256 cellar: :any,                 big_sur:        "3ddb2ae111832e46648ef4b0bf73bb890f96afd6cdb5dedc847857162163079e"
    sha256 cellar: :any,                 catalina:       "18fe5004080acea3a2799a0e1bce34e0382bea9528a1ec036267c1eb8a702e3b"
    sha256 cellar: :any,                 mojave:         "7375bcd75ec034939751ee0f44dd703ac81431957a92712d26fec1682e00ebc7"
    sha256 cellar: :any,                 high_sierra:    "a42e90e02b4074e0c864ae32fe5833977cebd50b8f9c74339c7a91dcf169b098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d50573d98593492aefbae83f872366e44915d241f975a9f3213c6fbc59b6a1f8"
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
