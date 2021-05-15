class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/4.2.1.tar.gz"
  sha256 "07a1bd8320902d7a27b933e8af6e0406f9098d407bde42cc849b4761e63d314c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c360f31b01c06a0f9edc59d5078427e8cf18329237c57a0bc24041f528db1346"
    sha256 cellar: :any_skip_relocation, big_sur:       "df909eae7276929eec1fda5e0fa2acf9e024e47d8493f9b4e3cc709a7e4d21a5"
    sha256 cellar: :any_skip_relocation, catalina:      "6456fa688f3c3ca7e546670bdc2484eefc2204868038d561fb3a4224ace7953a"
    sha256 cellar: :any_skip_relocation, mojave:        "96e53ac34cd7650d31cb51d5138dc7cd88345f395b2963c40ae6acf09c41564a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
