class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "4ae16eafe3b90abdc71ad172f10b8777dafb0edb173c66ab5f81c89dd49506ea"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "095aa93118a1523b51121933b5b606abfcae2a6a7b01436abda5963376c5ce77"
    sha256 cellar: :any,                 arm64_sequoia: "b7918edf3f305ba5cf52f679294d28b7c5137f4f748166c2d046a0e8a4ab012c"
    sha256 cellar: :any,                 arm64_sonoma:  "c9c329b458801de6b763a23f98922496aab469519b7069aaae534b09024c4d9a"
    sha256 cellar: :any,                 sonoma:        "2c807bab155fd312d9352580670307ba82ac8ad42ec12b74e4a6c233d2b2e524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27a78210965a49967967530e1c05c3812531becc813cd1362a5ee01ed90ef525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f64c0fc585d2fb2b22fbd7fc58a721c51fa8c2110f2938e01a30ac5d0672a4af"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
