class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.2/pie.phar"
  sha256 "2333b79a39c31b66b832e938b4a73a5682dace5d98d3745053debbe05d39439f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0626df23558016e9e41ad044e2110c9e88663e1c90795406eaf3c3cc70f27f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0626df23558016e9e41ad044e2110c9e88663e1c90795406eaf3c3cc70f27f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0626df23558016e9e41ad044e2110c9e88663e1c90795406eaf3c3cc70f27f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e10126d3a81080bde01e384a77a387a0f8778f0dd21f083f7428346b4871a14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e10126d3a81080bde01e384a77a387a0f8778f0dd21f083f7428346b4871a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e10126d3a81080bde01e384a77a387a0f8778f0dd21f083f7428346b4871a14"
  end

  depends_on "pkgconf" => :test
  depends_on "re2c" => :test
  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
