class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v4.0.2.tar.gz"
  sha256 "f540b788ac761ba20099c6710c3276dfdab9119906c1e9834b7648c0b633a000"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d64ae1d1ac76e5fefab707194a9e3507637a3802cdb99f9d2a5cb9445b2e83b" => :big_sur
    sha256 "8a526f4ed5017b9473701529d82f571d771201f75291f7d28e34ae2997369c2c" => :catalina
    sha256 "6f5a043137f073691026e73f2e78956339efb79645dfcc6cf8f4f1687c695a53" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
