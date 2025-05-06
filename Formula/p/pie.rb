class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/0.10.0/pie.phar"
  sha256 "a630d071d0618f7cfbd1ca5ea9afcdcc67645546629a1d53bf4329628708d341"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98291430aca19e4edf96f7fbc8c99f4ecc7db1611d794317b0549b1f08ff28bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98291430aca19e4edf96f7fbc8c99f4ecc7db1611d794317b0549b1f08ff28bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98291430aca19e4edf96f7fbc8c99f4ecc7db1611d794317b0549b1f08ff28bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e475ddfc70180d2081eaa686563173c1bf1aa432c8023153ae5ddc60ad7c167"
    sha256 cellar: :any_skip_relocation, ventura:       "0e475ddfc70180d2081eaa686563173c1bf1aa432c8023153ae5ddc60ad7c167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b17e1276d8f6e2c740e50a01624017d3154ad7a622fadcc9ce6d594c005249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b17e1276d8f6e2c740e50a01624017d3154ad7a622fadcc9ce6d594c005249"
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
