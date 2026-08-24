class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.10/pie.phar"
  sha256 "b88792235c8e80be568436d4cb043b49fd1869c89b64e83d23e2882ae19d70a8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baae917ed758cea16f5b9c168d86a4b0ef82156c65a0e22b6860af18865bafa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baae917ed758cea16f5b9c168d86a4b0ef82156c65a0e22b6860af18865bafa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baae917ed758cea16f5b9c168d86a4b0ef82156c65a0e22b6860af18865bafa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8506d994669184b540a39a841aabca66996b2549b7082e551b37d59ecf5318be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "691d3fe2c6c0b70d801de76f0107f49e9e1efb57b594b7f87cd78704f1437486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "691d3fe2c6c0b70d801de76f0107f49e9e1efb57b594b7f87cd78704f1437486"
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
