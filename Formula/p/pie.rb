class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.0.0/pie.phar"
  sha256 "6fc822f6a779865fd1ba297b2dac920a41b81dffeb829de8162e11c9989add8a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3df4fe0b33fa3f262fdc3a24d5b17c07c0ee5e507717edc3396ce1ec2041f4c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3df4fe0b33fa3f262fdc3a24d5b17c07c0ee5e507717edc3396ce1ec2041f4c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3df4fe0b33fa3f262fdc3a24d5b17c07c0ee5e507717edc3396ce1ec2041f4c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f1a52b83bcb631dd135d9e74e573e6d74ca4b2114a93c4c2b2e81a07dd8dde2"
    sha256 cellar: :any_skip_relocation, ventura:       "1f1a52b83bcb631dd135d9e74e573e6d74ca4b2114a93c4c2b2e81a07dd8dde2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f6d113f9f79fc032ef075c82723d15a6d77d1791c2e9645cd790945249f4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f6d113f9f79fc032ef075c82723d15a6d77d1791c2e9645cd790945249f4fe"
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
