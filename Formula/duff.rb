class Duff < Formula
  desc "Quickly find duplicates in a set of files from the command-line"
  homepage "https://duff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/duff/duff/0.5.2/duff-0.5.2.tar.gz"
  sha256 "15b721f7e0ea43eba3fd6afb41dbd1be63c678952bf3d80350130a0e710c542e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c383331f4c0f5f8efb8364079dd76994d6e210e4bdd4d6f8e96c53d55ee88d0" => :catalina
    sha256 "b2f5b9c19bb74d92c6b43482b77bf6d852355b83ddfda7ca4f6340a8075067f4" => :mojave
    sha256 "a30c57c79b3cef30518fccc5227e954dd9a2383e15458f85706733dcc1fe188a" => :high_sierra
    sha256 "2af1262a9b02e687c0efc14eed3d837920ab746fe8fca9b12b9361c4729f06ef" => :sierra
    sha256 "8a469e92a6303d80752ebc80ade382261d263b9c7226ca6652eddc8954e5ff2f" => :el_capitan
    sha256 "927ba61ce39cf9be33f796197063b1a6865bbc2db2f4b1340ad6786acf0494df" => :yosemite
    sha256 "a66cbddeb95dd67055ef6db7acf729a925427778d6cc88ed2ef52a2dd40b7856" => :mavericks
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
