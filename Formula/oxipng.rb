class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v2.2.2.tar.gz"
  sha256 "f2addda729b287ce02a2b853aaa22420ee00cf20e178d6f2238c03438e89c7fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8f8e682147291929ef495846f8bd5c965b2618846e3f538767c1d58cefb1e6b" => :mojave
    sha256 "9e0d074376b2d2a7e07268442e73290030f7e2b997e1b22f5578c780a181cd83" => :high_sierra
    sha256 "eeaea2846f35f079899e7085efd0cffca1370062652f0ac4963631dafae5b9a5" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
