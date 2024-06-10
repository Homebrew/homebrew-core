class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v3.11.8.tar.gz"
  sha256 "a38ba762e57a0aa5d7040f818a1ddbb613c42bf0432c897e33a99d21388ecdc7"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d8f941a9f53adeacef6f2e97471859cac7708953e80910d6334d2d0f36b3917"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea0ce27b7dd80feb60e6400a2efc9055d6a0c27e5a3bf2c4eb9282a508bfbf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d6133534d1703c4ccc98ef387ab12f3a02b2fe7f63efa79f3ad87198d96439b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a685420a86995a526138716548fe51cf625437cd672198035118f8d6880ea9ed"
    sha256 cellar: :any_skip_relocation, ventura:        "534e5f1a0e781c6a155c43ccf19a3a64add1740f78b77bf32717a524162713bc"
    sha256 cellar: :any_skip_relocation, monterey:       "aba744143a252b0d1e6d858fb789b183038362a2f60864c90115dabf65001d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61bdfe98fddb9c2185462ca1a159257363c715fe45ebe4268d93972831f25b99"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
  end

  test do
    output = shell_output("#{bin}/gomplate --version")
    assert_equal "gomplate version #{version}", output.chomp

    test_template = <<~EOS
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    EOS

    expected = <<~EOS
      foo
      bar:baz
    EOS

    assert_match expected, pipe_output("#{bin}/gomplate", test_template, 0)
  end
end
