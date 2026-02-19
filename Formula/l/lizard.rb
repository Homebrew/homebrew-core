class Lizard < Formula
  desc "Efficient compressor with very fast decompression"
  homepage "https://github.com/inikep/lizard"
  url "https://github.com/inikep/lizard/archive/refs/tags/v2.1.tar.gz"
  sha256 "0c1a7efceeb8ae66bfa2b7b659f01dec120925d846b01ce4dfc6960ba8cd61e5"
  license all_of: ["BSD-2-Clause", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "027cd559caf4e36ee689c1430cbd1d6719ef7859daf9f3b62fcbabeb52bf65c9"
    sha256 cellar: :any,                 arm64_sequoia: "a9de7741a01031727be56d4e8114c07ca8b108607393e7fc81de10a3ef38ac2c"
    sha256 cellar: :any,                 arm64_sonoma:  "f0096c7097d15b80a8b1380e9875f01dc9c774f9c4486037079e87614179b32f"
    sha256 cellar: :any,                 arm64_ventura: "6e41f950c3122da4196d7f1f9501e9c32f095465587090615bba4be931543f07"
    sha256 cellar: :any,                 sonoma:        "9bd2c13adb64d92944260e290b9416218f4eeb424487ea49ae83bb015ffd9f81"
    sha256 cellar: :any,                 ventura:       "39b3961d0fc7b870dcc7d375782ccd5c51ac716e4a3ef8bb6ffa16431409ae37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6212d114544ae8160922823d29a649f51b2bb89fe30a114e93b6b063e9ebac0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf6aa7976a0ebf3f70dca4b20b19dac4cebcf104d40806af223fa0be2b0607f"
  end

  conflicts_with "lizard-analyzer", because: "both install `lizard` binaries"

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
