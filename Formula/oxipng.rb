class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v4.0.1.tar.gz"
  sha256 "c5684730757a49a55c3bac66de139da5a1fdcd190f8ea3b9a95e1fc8feccb106"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "779e480284ae1f84378ebe55d3fefb8094eab04b7685a2ec71ce5ee04f78ccf7" => :big_sur
    sha256 "731dc0bb62382fcc1ed327a9991af54c8b9e5a3744390eb0f33a820a2d76fba5" => :catalina
    sha256 "e7a6e4f1073c53479339da86dc958fd1cf7337892f7a6ff471437d9a03f9d4d2" => :mojave
    sha256 "78c733696edd12b4c76459399d792d0723bf469d1add45449b26d19877843be9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
