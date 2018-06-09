class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/0.6.0.tar.gz"
  sha256 "ab20d1c9c20f3b25d0be62fdb8aba74c0e2f046e647327d85a0ecc84d40f8a94"

  bottle do
    sha256 "87d766593e0414423a19d44e2fcb390f1962cc28d936e572c04207fc8ae24dc8" => :high_sierra
    sha256 "a91317384a098631c4393858027f79d96515e611400fa850a50ec29898d5a85e" => :sierra
    sha256 "ea6da90fb396dd9c690c0d9db851fd91af49c19873c6e4aba047baa26921135b" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    assert_match /Available modules:/, shell_output("#{bin}/genact --list-modules")
  end
end
