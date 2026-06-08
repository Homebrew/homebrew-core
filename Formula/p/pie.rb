class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.5/pie.phar"
  sha256 "6cdc03b8861b290d4e2a61147082a9f21dac5af572c66f0d121f266361499662"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e549d5c12212f713b45e11a7280dd0fe03e974b8ff5d1531971b7a9cf37c003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e549d5c12212f713b45e11a7280dd0fe03e974b8ff5d1531971b7a9cf37c003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e549d5c12212f713b45e11a7280dd0fe03e974b8ff5d1531971b7a9cf37c003"
    sha256 cellar: :any_skip_relocation, sonoma:        "a82548f6221eebdb3e6156aba05d2dbca7a131f4627342c7a267dcdb60fcd0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a82548f6221eebdb3e6156aba05d2dbca7a131f4627342c7a267dcdb60fcd0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82548f6221eebdb3e6156aba05d2dbca7a131f4627342c7a267dcdb60fcd0ba"
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
