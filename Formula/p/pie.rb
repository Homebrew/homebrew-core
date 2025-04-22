class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/0.9.0/pie.phar"
  sha256 "aeebc24f7c362f95bfcf201f40f1571a996228a2871570d9cea412909e9200f0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd56e655672a0ce488344d48b31e52f35552ea11fdb492f527b5133f4536e45a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd56e655672a0ce488344d48b31e52f35552ea11fdb492f527b5133f4536e45a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd56e655672a0ce488344d48b31e52f35552ea11fdb492f527b5133f4536e45a"
    sha256 cellar: :any_skip_relocation, sonoma:        "06a6018d8c89fb491696b4e098d747ca0c00b35e86bc74cf3d2b466e27898884"
    sha256 cellar: :any_skip_relocation, ventura:       "06a6018d8c89fb491696b4e098d747ca0c00b35e86bc74cf3d2b466e27898884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b37f3a48e57c68daec6015bacd678cc16d2d8df6fb93b85f6f4381a9e6b8aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b37f3a48e57c68daec6015bacd678cc16d2d8df6fb93b85f6f4381a9e6b8aa0"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
