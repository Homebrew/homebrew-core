class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.4.0.tar.gz"
  sha256 "8e7e496a0829fd987a68575968926f24df4411a2ff87842e25ee15a0995e7590"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "375f09da5a8d8b4256595a488d135b1b36321d260bfeb520685311c6d5de6d3b" => :mojave
    sha256 "c7b02085433b3df1e964bf4cd313e6db856d47899abf3a19e53e0f2d8e325131" => :high_sierra
    sha256 "5174b91a63eb7636796ef06e778309bb501ece9f6b4a2be423faee5bdcc41bb4" => :sierra
  end

  depends_on "go" => :build
  depends_on "upx" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hairyhenderson/gomplate").install buildpath.children
    cd "src/github.com/hairyhenderson/gomplate" do
      system "make", "compress", "VERSION=#{version}"
      bin.install "bin/gomplate-slim" => "gomplate"
      prefix.install_metafiles
    end
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
