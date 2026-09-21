class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.5.0/pie.phar"
  sha256 "d195dc35d311b6e0d5e2a3bd02893628f9898db3c004563f0c3a333a02010873"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23da6ec2f28c61ec08c7fc333b76e771e2e49cca4830550fc7d7bbf782baca18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23da6ec2f28c61ec08c7fc333b76e771e2e49cca4830550fc7d7bbf782baca18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23da6ec2f28c61ec08c7fc333b76e771e2e49cca4830550fc7d7bbf782baca18"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a35ad98f930cb7bdaf8cc33343aefa909e589b40703bcde08a25a0f59d6514ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a35ad98f930cb7bdaf8cc33343aefa909e589b40703bcde08a25a0f59d6514ed"
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
