class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.7.0.tar.gz"
  sha256 "cf4ca68c81894c6aae4a618f31fe8f09cbb86580c58c33729481194f3c4e2aab"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88cf5acdba5d5558ce1432c00c63969a2832a47459eac91d8854ba6655479892" => :catalina
    sha256 "91f6db91eb3d9a33801b48612c4b5b8b3525eb60373081bea7bef213553a807c" => :mojave
    sha256 "b1bd2ca2cba7b66040780f5284b280dc5b02f589ef7f238afc1777c9e547a3a2" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "upx" => :build

  def install
    system "make", "compress", "VERSION=#{version}"
    bin.install "bin/gomplate-slim" => "gomplate"
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
