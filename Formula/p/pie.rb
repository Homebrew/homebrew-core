class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.3.8/pie.phar"
  sha256 "f522f45507170b940a0003bc72a15a29d25bbf094ff85260ffe687aca3f319da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81e4ca23746edf20e285230b29b89bf4eaf62808fd8998c990cfdb975d35a59c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81e4ca23746edf20e285230b29b89bf4eaf62808fd8998c990cfdb975d35a59c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e4ca23746edf20e285230b29b89bf4eaf62808fd8998c990cfdb975d35a59c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6510e7f3a9d5664eb5115a72645e194e3d548a23bd814784787e8d9a1ddda892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6510e7f3a9d5664eb5115a72645e194e3d548a23bd814784787e8d9a1ddda892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6510e7f3a9d5664eb5115a72645e194e3d548a23bd814784787e8d9a1ddda892"
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
