class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.14.0.tar.gz"
  sha256 "b83285d97f1df5602647749829fdcdbcf21ece273c669bdb8e62544238b1f54e"

  bottle do
    cellar :any_skip_relocation
    sha256 "041e4580efb9e9b7d02c81a3865ff346e5793c7678332218d4b883a4d73d9341" => :catalina
    sha256 "c2482575162f38c552774b8d833100a465a9861a43d8f748c4565eb2fdfa1302" => :mojave
    sha256 "1268810769bc7b1f6ee99a7d600ab599aeca5ac37ae3a89ae7ed8994355f191b" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
