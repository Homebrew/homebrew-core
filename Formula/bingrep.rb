class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.8.1.tar.gz"
  sha256 "a3d93a3e30f306e5273b95e212007cff5918423d2386233a8625b7f3cf18a0e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c370465c0e36f286d7051007df4cc8e9830f68e8b04ca1b41471396ab5bd3300" => :catalina
    sha256 "9f15cee5770b2bab318aac00b20c60f2b82c81881d99f934420c863c64bc2295" => :mojave
    sha256 "352b163b9239facdfe846d9eb0d0c73f50d2681ced80645ecdd69818942dcfed" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
