class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "6f2481f8e57e5bc0301a8e9234008997649a6076f866bbec6d30bee8c93aa6e6"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a7f54ee5dbd15945f5a6ca4a88c1d6cbdb7adaa05663e5bcf2bfbc7514e80ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2f727ddc32701fcb7c44e94c146998bcae3155e5542536aa65e9da1cbd7a1c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b4b21d75709d75ec7164c31801d7610168a63ea3c606994209a4648e95ccaf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0401459ace21ca5b25f04d129a4b8f48c5b9fb8c46aecd12124b2059b73dd85"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1a6be71ab8f828078f27bfa4536c37992452bba6306931c15546a70ce0a3035"
    sha256 cellar: :any_skip_relocation, ventura:        "57acb0b98fe9a50a442d3153ae74a83ddfb41934d1f23172ca80561b3b77eae8"
    sha256 cellar: :any_skip_relocation, monterey:       "030adc882b1ce35c328b8d44708f765b76dbd9b609f0aed1c9e200c4e789dbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba294d67e3e1cddbf5332bce359e26822a8c1f8d555cf9e2e2ac5f940a67924"
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

    assert_match expected, pipe_output(bin/"gomplate", test_template, 0)
  end
end
