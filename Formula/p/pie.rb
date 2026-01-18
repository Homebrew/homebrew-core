class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.3.5/pie.phar"
  sha256 "402ab3b5482b32b4f89fa27ff0332b9f3c21189300e891a0593348e548100586"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6b087bc46c5d6a10d2b75a0a7fe5888cd97fb5a82edd564c7a1dcfb73b1d65a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b087bc46c5d6a10d2b75a0a7fe5888cd97fb5a82edd564c7a1dcfb73b1d65a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6b087bc46c5d6a10d2b75a0a7fe5888cd97fb5a82edd564c7a1dcfb73b1d65a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fbdd4e0589382e258a09045e254adfa31f288152015c72e69a3fddbe7196634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fbdd4e0589382e258a09045e254adfa31f288152015c72e69a3fddbe7196634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fbdd4e0589382e258a09045e254adfa31f288152015c72e69a3fddbe7196634"
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
