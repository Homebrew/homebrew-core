class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/0.8.0/pie.phar"
  sha256 "37b0e76f38df0e10dcaf90f9887320ba2a11d8d2c1c28f76f43f73eb25c13db5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e417f2d7a2dabba0e7db180743cbaa3a609ff551de1dcad70915df508d6454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e417f2d7a2dabba0e7db180743cbaa3a609ff551de1dcad70915df508d6454"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1e417f2d7a2dabba0e7db180743cbaa3a609ff551de1dcad70915df508d6454"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d3a7d9680e8c9cfdae6e72061dd82da043c975c62dc1d0bfae36e86b77a860b"
    sha256 cellar: :any_skip_relocation, ventura:       "5d3a7d9680e8c9cfdae6e72061dd82da043c975c62dc1d0bfae36e86b77a860b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917404edceed6aa8a3371d071666d4f308d83235d0f9afdf5f1e00229434614b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d4060c9f9ae22433f55d04d1ba40738f934d636b86014647e357600d4f5cc8"
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
