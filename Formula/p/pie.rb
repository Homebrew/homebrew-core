class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.1/pie.phar"
  sha256 "96a48a407e3e670048aebbad0fff0314cfa6a1a502b81d62b91e45f6f1c2640c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee964a98b14dbf96127320e21a1cd31645a7a7e88898492b6223c8a6a4461a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee964a98b14dbf96127320e21a1cd31645a7a7e88898492b6223c8a6a4461a34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee964a98b14dbf96127320e21a1cd31645a7a7e88898492b6223c8a6a4461a34"
    sha256 cellar: :any_skip_relocation, sonoma:        "74325b010f05bc73e62220096bed8035160baa1e7eecf736ebfb83160b07667c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74325b010f05bc73e62220096bed8035160baa1e7eecf736ebfb83160b07667c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74325b010f05bc73e62220096bed8035160baa1e7eecf736ebfb83160b07667c"
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
