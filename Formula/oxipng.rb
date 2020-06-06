class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v3.0.0.tar.gz"
  sha256 "fd7584299375a630322b152878756297b0083492b7e4b9b17ae9978662e8c36a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f20f3249448d24f2c8b6a4d3a846a0e1f0d9263dba6d0f4928e809ddb7f0c3ab" => :catalina
    sha256 "b459a4e6735e871902cc7b8384f2a3112604ac94b31dbeca160b8438e3b0d466" => :mojave
    sha256 "a2dcb80edca41256bf33d7b341aeb75c68ae5760c4268c5fa1a6f61248b8cfc6" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
