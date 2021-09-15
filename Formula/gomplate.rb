class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.9.0.tar.gz"
  sha256 "75f69367e004b427a80d4a8886428b86216bffcbbe4caeb5ab16d282ea1d2cbf"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed2cd30c30d5ed64152c9eb5999cf00c3d1f6afe10511877542fbfb17dffa950"
    sha256 cellar: :any_skip_relocation, big_sur:       "a15da29726d37e73313a776a78a2d5bfcdb1a0a950e08794a097d87db759751a"
    sha256 cellar: :any_skip_relocation, catalina:      "a0f5d247cd90c04f01050147f3120754bece918d15d711fb775cd6c162237c2b"
    sha256 cellar: :any_skip_relocation, mojave:        "b7644a65c9bbc0e9816ff2a3b6e4b196f4bab4aa267a9d9ed65be1a5f737d06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22548c1340f1fb2672e4777996966143e8d4c4379989ed802f78390945255471"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
    prefix.install_metafiles
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
