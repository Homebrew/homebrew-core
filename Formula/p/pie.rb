class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.8/pie.phar"
  sha256 "ef9f19c2698334aa8ce8fc458c8cf2a31a2fd6a29230216dbde3422343cf952d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc8248e2284710d2c99cfa005cf98e6ff68e3653c0b20f92a05ef1ae0180c348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46178089744de42bbfe5800d16d23ce5aaa48285ed3b0f09ba542f9476d95e4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2960f95ddb6ab9600ad2e4a538dc6f4cefa3aa603011d5fa397284d202e5ce49"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede3e4aeb25bc30210b04d8f9f74d47b7c689693868750900506f86167c4c959"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a49e6973c4a3c46fd31db305ea8ef369356dc5c67729dcb3a2724638763ce60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35e13923ca0cbb50b281d70f2a51e23e4f5cd542c38338029a8567540732f3b"
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
