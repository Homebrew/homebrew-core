class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.14.tar.gz"
  sha256 "c4ed13c04880ccc3a85a99645dcb64134beac8ab0607fe32a4d07e1057ad73b7"
  license "MIT"
  head "https://github.com/jech/babeld.git", branch: "master"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8df1000e25e05a3dbbb5216051fab8b7dd8a340a307924faf4537c4b8e2e58f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e46f543ffdff4ba057e8f007200fe9973c9a3b227e8034e140c570da9f8db8e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeb49eecbae6ebeb3d637a7546ac790ed6e4280903969d2d3561fcec1f90ee48"
    sha256 cellar: :any_skip_relocation, sonoma:        "185f1c12cb07e891707585e033b1188ea31a61fd5d879581d14b74c3ff4af43a"
    sha256 cellar: :any,                 arm64_linux:   "bfd5b5f5d460c9df85796fe9e9d521077e7a2842706a47551daadc10b13fc024"
    sha256 cellar: :any,                 x86_64_linux:  "066c81b6f7cf20af8094d4425e090d322788a98591444d3902a802c5fda52e05"
  end

  def install
    if OS.mac?
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    else
      system "make"
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    assert_match "kernel_setup failed", (testpath/"test.log").read
  end
end
