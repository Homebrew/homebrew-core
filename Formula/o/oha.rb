class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "306973c36a9e2fd2ca9c5d830b2b718485217cab25f71c0774e7f8d7089833cc"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "092ef5f5ec410a679c07319c70203e3e6121f1433a6ca92c195c382dcb7a891b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9038f3c268573b8177dd6ab51cc4859661efcaca531905a18fe422a142300b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e246d5534ba4aa54a906d8261a930465e8c7ce07bdd407dff1c804ec1604c4e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eb07632bb4b8b8e646b97e5b233dde79c4715f0b2e10892a0843b39aff3ccc5"
    sha256 cellar: :any_skip_relocation, ventura:       "85fb613acf82f6e7da742298aea980627ed91f451e8ca55bc677e4c10f6de4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5822ffd5d4b5fc56508802b42a37c93df0aa37c4a3e0e6f9b5092d3e0631b1e1"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
