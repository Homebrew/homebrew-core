class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v2.3.0.tar.gz"
  sha256 "870c6ab802ca4df6d12a5570b6883e7e3b190bbe6e2fa91282af9b294c8e68b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "0182e86e8e3fd41830fc14bed1558708800a84e1d649ed6f604e96d47eb4996f" => :catalina
    sha256 "408eee54c280226f4873af25d8243f64bd09cab18ed42296ac76f401f98f48dc" => :mojave
    sha256 "add9f882e9b0573fd3c97b1f68336075c626f2e48f07a937350d57d985230bec" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
