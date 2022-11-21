class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.26.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.26.tar.lz"
  sha256 "e513cd3a90d9810dfdd91197d40aa40f6df01597bfb5ecfdfb205de1127c551f"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faa860db4715963f220c26412211476871b9de334cad2a0a250177f3fafdc6c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7e53ede5ffb258402da89d8ec5caa6b7b430d2d09b736f625f1b95c30049125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7da116694fc665cca45f353ce50732a15bfb3628d8e1c438b30325ecb696efc"
    sha256 cellar: :any_skip_relocation, ventura:        "55a83c6eb96c7261d49068b16f0b228d185e22b36d58a0e69b3ebaeecb0acd6a"
    sha256 cellar: :any_skip_relocation, monterey:       "5d90acf7354dc1734a50f2b0e2aaa9063da223ab7373e076ef3d803f94b48a4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ac9aec95d746be7efee55c9666bf5f43b3feb60049d10cd06748a68bf5d68f8"
    sha256 cellar: :any_skip_relocation, catalina:       "78a4d6ab9370c966716ae4e9b4ea10bfc724af6bb4516d9e18b16ce3546c87e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44286f1d0466b4906edce7dfd63796907d85c0cb57c6415ec2dfa2d5a44603b"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
