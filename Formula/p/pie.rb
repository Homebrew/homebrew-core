class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.9/pie.phar"
  sha256 "19a31ddd4bfd08b9eb5eaad2e5f63e76e7919cae7683852da41c80da704ad6c0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "049177b2d7e0190189c78063c36ef4bc9357cd0a8d505c1f76885f5157513c33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "049177b2d7e0190189c78063c36ef4bc9357cd0a8d505c1f76885f5157513c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "049177b2d7e0190189c78063c36ef4bc9357cd0a8d505c1f76885f5157513c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0758b8a7da4ab07df011cd4989222af9505d4f5a3ecf39c706f175d0a52af3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6888d577e9aed6582f13cc286a9e4de1542a9b022f8330e158c54e2ead925b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6888d577e9aed6582f13cc286a9e4de1542a9b022f8330e158c54e2ead925b8b"
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
