class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.4/pie.phar"
  sha256 "ab2810068b4b4b42aa35448463644ed0d1e74c99828746a0d05409f0433164c3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f781f0cac7aba9048c6bea2f322c104f4fb5d30186d929006c60a9cb0600b10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f781f0cac7aba9048c6bea2f322c104f4fb5d30186d929006c60a9cb0600b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f781f0cac7aba9048c6bea2f322c104f4fb5d30186d929006c60a9cb0600b10"
    sha256 cellar: :any_skip_relocation, sonoma:        "011769feb3a3c702e38e61c7525cad8b33784c88eebb4678204c9b843d7acf82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "011769feb3a3c702e38e61c7525cad8b33784c88eebb4678204c9b843d7acf82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011769feb3a3c702e38e61c7525cad8b33784c88eebb4678204c9b843d7acf82"
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
