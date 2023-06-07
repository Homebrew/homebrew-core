class Hfsutils < Formula
  desc "Tools for reading and writing Macintosh volumes"
  homepage "https://www.mars.org/home/rob/proj/hfs/"
  url "https://ftp.osuosl.org/pub/clfs/conglomeration/hfsutils/hfsutils-3.2.6.tar.gz"
  mirror "https://fossies.org/linux/misc/old/hfsutils-3.2.6.tar.gz"
  sha256 "bc9d22d6d252b920ec9cdf18e00b7655a6189b3f34f42e58d5bb152957289840"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8245a9a524d4f34c9a005a09a56f6d190ec20583c43fb8c1317fbc13827fc37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d74c98e3e180254629b1dbcf8898a6de9167d28feaabed35b76d3aebcf84b5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "107acc6f2b286756c2d74d4973eb367071d53ed4271aabfcdde504818f2458ed"
    sha256 cellar: :any_skip_relocation, ventura:        "cf4d77dfdb1ede0dc9b5cbdeba835284926b201d5f8afc7830d7fb59bb68b39f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ae0944174c9dd94812396503c259d281061fa2706f610b03d538d9e502b17c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "133b4b04a161486e76ca06ed4e78086a83ce7ed238b10b879f78a93d66d9dc68"
    sha256 cellar: :any_skip_relocation, catalina:       "5a0e074c5fdcfb43508e049941dd5d7384a7f4843c8d0fe3df325880a45823fd"
    sha256 cellar: :any_skip_relocation, mojave:         "f32eb0e176bc5f5939a12599f0dbc808631a7680e21b5f820cc096e00fcec46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4614155fc7221a5410f47eac547e8c6c906bfa9965acfc03433fee57a997c9"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=disk.hfs", "bs=1k", "count=800"
    system bin/"hformat", "-l", "Test Disk", "disk.hfs"
    output = shell_output("#{bin}/hmount disk.hfs")
    assert_match(/^Volume name is "Test Disk"$/, output)
    assert_match(/^Volume has 803840 bytes free$/, output)
  end
end
