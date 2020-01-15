class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.6.0.tar.gz"
  sha256 "b24c574a7646461911e5900a84c31b249abf65714cffb9c64d64e4b575751c74"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef111dcdd62072e6b1293da6d767099be4140f17ba9b5d595f85a44d93440bcd" => :catalina
    sha256 "c97ce8c1f02a1ce4fbf9ae9680e8f70838289cd1db9a625d71922f959bdb22b9" => :mojave
    sha256 "7253fa83fb15068b94a95c12bd74f27fdf55ad68e3e78022ae26a82df0f6f0b3" => :high_sierra
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
