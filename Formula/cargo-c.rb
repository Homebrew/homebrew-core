class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.5.3.tar.gz"
  sha256 "3a4860898f68e59a1eb9f19c7f12690b6399ddd916c7bc188c1f01cccdade7a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "e233ac8f1431e372e1774b1ac83d8e2ca4b8e8a9041a032a706c6e066c9b84d9" => :catalina
    sha256 "fc469c48e26bd15732192540ca3ae269d4be199416cc53fb1b9f08c504507f60" => :mojave
    sha256 "11900b65b751d322c77428c5f4508cfa47b5e1a7326a4d91ca3ffc8b84541a90" => :high_sierra
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "cargo", "cinstall", "--version"
  end
end
