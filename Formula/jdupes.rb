class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.19.1.tar.gz"
  sha256 "bb7c53cd463ab5e21da85948c4662a3b7ac9b038ae993cc14ccf793d2472e2e9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bf871f37dcb362d686dd45943fe9c99450f1c63a87cd5609b9c3a87f70c3fc84" => :big_sur
    sha256 "514a2dc2113a9ee6018bb9341064fb10437808ccab19028cf7d5b36131b4d31b" => :arm64_big_sur
    sha256 "e45323a13531cfbe654f20187dfc34439979748e9f19c8b31c3adf8fc500e289" => :catalina
    sha256 "3480a8d00c48aebfe2372034f5da4a9864a4a58afdda59ecd24420459726f6fc" => :mojave
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
