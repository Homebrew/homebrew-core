class Clzip < Formula
  desc "C language version of lzip"
  homepage "https://www.nongnu.org/lzip/clzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/clzip/clzip-1.16.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/clzip/clzip-1.16.tar.gz"
  sha256 "f339a3a5dfc2220532dc36f937a7a58e3a3278b174f2815cc5615107e55966e4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/clzip/"
    regex(/href=.*?clzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ee9c3f89bcd79ff5f4c8b6618d5b33183e049d42c294b39c9f8f49e27642f0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c127aabcf849b0535467eb2a49acb2c53a3140c82c36aba605a8d80666e44a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba35ec502cc419efd0e97c7ca5d71776398e4cd5c1ab32dc197a6b4633f83352"
    sha256 cellar: :any_skip_relocation, sonoma:        "9511e3a7bd3933091134aebf40781224f50904fc0a9deee4a6613003033bc2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cedbc869236e712a5d6b548799f81e4f5e8c0bdb9e789f06e3d8afab8dac9655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "172b8fcc9ba87b1ccc92bacc37a41ac8ddc2080e40d9ed553d8e49f33d1b2c49"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
    pkgshare.install "testsuite"
  end

  test do
    cp_r pkgshare/"testsuite", testpath
    cd "testsuite" do
      ln_s bin/"clzip", "clzip"
      system "./check.sh"
    end
  end
end
