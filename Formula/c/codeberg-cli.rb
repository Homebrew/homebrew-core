class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.4.7.tar.gz"
  sha256 "a8d1356faab84076f14977652dabbfcad4411f49beb4d11a1bc0ee8936bd1d6c"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a764c3f1e6b3a4187050e62ec0606f5b0c41b542842dd65d8e7bf3a0186219c"
    sha256 cellar: :any,                 arm64_sonoma:  "9195c2c7ee00ce0809b185a7060a54242aa44bd7797e2a2eac77f1d8a4f204f2"
    sha256 cellar: :any,                 arm64_ventura: "ee265e81ca7146a9942ae8d60b11f34709a6b2e2fd5b3cebc1136f1d561bc555"
    sha256 cellar: :any,                 sonoma:        "160a1990a673c56f3e3cea058c8ac23a952fb95ed5ed60838feec93d6064e5df"
    sha256 cellar: :any,                 ventura:       "11b46470d5f083410b2d0b6af069deff3081ed5a317836f8264682c79362db37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "407a3a9e6419a3485e85bffa2ed27c8a1b35885240cd2c0b23b970d0e1dcd4cf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"berg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berg --version")

    assert_match "Field    ┆ Source   ┆ Value", shell_output("#{bin}/berg config info")

    output = shell_output("#{bin}/berg repo info Aviac/codeberg-cli 2>&1")
    assert_match "Couldn't find login data", output
  end
end
