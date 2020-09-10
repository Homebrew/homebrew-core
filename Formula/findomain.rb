class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/2.1.4.tar.gz"
  sha256 "e669e5297c3112ec4e256bef286028220dcb9d46cd8a31e6965cbbc3d2ae3199"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "fce8bf924154a08c34e8626a304e56ceb23df488bcb8812ee5ef7469de004fe6" => :catalina
    sha256 "d07b7814b14c4a8df3d895b99f26b67afa635cadaf1f55ad883a852be9668633" => :mojave
    sha256 "d16debeeda53cb1d480eba54b60e3af9eb68bfe61a79db361cff6b937eb96edc" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
