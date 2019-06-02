class Lizard < Formula
  desc "Efficient compressor with very fast decompression"
  homepage "https://github.com/inikep/lizard"
  url "https://github.com/inikep/lizard/archive/v2.0.tar.gz"
  sha256 "85456b7274c9f0e477ff8e3f06dbc2f8ee8619d737a73c730c8a1adacb45f6da"

  bottle do
    cellar :any
    sha256 "d6d2770f6c346dbb095dbcc69f6b1cf79613d94c1777f07ca3a79ca8883e4ab6" => :mojave
    sha256 "9790144aee9e270729e23ed984748987805161a650f970d453b706ac950cd5a6" => :high_sierra
    sha256 "2bd42482a27e4b9c4deeb61ff2d9e858161080ced6e54e69bbbc59da6df885c3" => :sierra
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
