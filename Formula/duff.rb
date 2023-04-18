class Duff < Formula
  desc "Quickly find duplicates in a set of files from the command-line"
  homepage "https://duff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/duff/duff/0.5.2/duff-0.5.2.tar.gz"
  sha256 "15b721f7e0ea43eba3fd6afb41dbd1be63c678952bf3d80350130a0e710c542e"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "176be0397d77a2aacf76fffda32a3d6e203eb7a803c626c52db2e563c2c49c3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "668a1d24b8d48ec315a92dff088af45703c461c93fb8b865ff76eb7e932eab03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a56fadd23b68f73dc6800cb2d13435b8bc8893b3b1cf3ce48660663840cab8a9"
    sha256 cellar: :any_skip_relocation, ventura:        "ae67b1af84e554db4575280152fe634369a8248c1ca9cc358d4247e553ee87da"
    sha256 cellar: :any_skip_relocation, monterey:       "486d0ff26e56d7a23692b429a3441d965f61bf8e48038f5d582c9a0da5c6379e"
    sha256 cellar: :any_skip_relocation, big_sur:        "37eec490b6068cb6cb98f430740042712203e2bd2db39bfe25eeb5143f444965"
    sha256 cellar: :any_skip_relocation, catalina:       "9c383331f4c0f5f8efb8364079dd76994d6e210e4bdd4d6f8e96c53d55ee88d0"
    sha256 cellar: :any_skip_relocation, mojave:         "b2f5b9c19bb74d92c6b43482b77bf6d852355b83ddfda7ca4f6340a8075067f4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a30c57c79b3cef30518fccc5227e954dd9a2383e15458f85706733dcc1fe188a"
    sha256 cellar: :any_skip_relocation, sierra:         "2af1262a9b02e687c0efc14eed3d837920ab746fe8fca9b12b9361c4729f06ef"
    sha256 cellar: :any_skip_relocation, el_capitan:     "8a469e92a6303d80752ebc80ade382261d263b9c7226ca6652eddc8954e5ff2f"
    sha256                               x86_64_linux:   "d2e177f7c17a8dad92be2c7597844a572e4db8a8c4bba5db934843325c5edc90"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    expected = <<~EOS
      2 files in cluster 1 (6 bytes, digest 8843d7f92416211de9ebb963ff4ce28125932878)
      cmp1
      cmp2
    EOS

    (testpath/"cmp1").write "foobar"
    (testpath/"cmp2").write "foobar"

    assert_equal expected, shell_output("#{bin}/duff cmp1 cmp2")
  end
end
