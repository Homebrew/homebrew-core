class Nat < Formula
  desc "'ls' replacement you never knew you needed"
  homepage "https://github.com/willdoescode/nat"
  url "https://github.com/willdoescode/nat/archive/v1.0.8.tar.gz"
  sha256 "3eb0e7e6e08402a9263ab76569c4dcd5ace82282ea06799fb1271b31bd4f1017"
  license "MIT"
  head "https://github.com/willdoescode/nat.git"

  depends_on "rust" => :build
  uses_from_macos "llvm"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/nat")
  end
end
