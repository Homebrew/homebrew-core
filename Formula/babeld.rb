class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.12.2.tar.gz"
  sha256 "1db22b6193070ea2450a1ab51196fd72f58a1329f780cb0388e2e4b2e7768cbb"
  license "MIT"
  head "https://github.com/jech/babeld.git", branch: "master"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc426ca2675ff81cf0a36bce7e830a01471eb3689f77940ba18a890c5177944f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13037d03bd5527bb13d13997f8111b34c4033108aeaf0c893530b75129491456"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31c29f829e6523fab89daf2eb092fa48abc7bbb3395b8a9b2f25919ee12165b2"
    sha256 cellar: :any_skip_relocation, ventura:        "6dc926128e3c43dab097b491e7bf81af73ba69caeecaf7b2ede264d70a8a0d58"
    sha256 cellar: :any_skip_relocation, monterey:       "12e48ee7897ff4639dc1ff8ba91e98db8cf46bade5fea51d4cb982a44c7941d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "271635240ac971459752fdeebc5177a9020daa15fa5f1d6d58e696fab6c550ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b34878106cd3d0cce9727157896340b5823dfdfcd00d0123a22c2041378a0de"
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
