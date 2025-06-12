class Frep < Formula
  desc "Fast find-and-replace CLI"
  homepage "https://github.com/thomasschafer/frep"
  url "https://github.com/thomasschafer/frep/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "3eb837d91f4005e78ab7dc55bdc3829d698dd851c636fbfcc35798de9841ea91"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "frep")
  end

  test do
    (testpath/"test.txt").write("hello world")
    system bin/"frep", "world", "universe", "-d", testpath
    assert_match "hello universe", (testpath/"test.txt").read
  end
end
