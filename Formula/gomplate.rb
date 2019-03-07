class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.3.0.tar.gz"
  sha256 "6dd8169f491405a6f410675bbca093153d6132322a6720d1eab98172303fc95c"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b9a5d81eb8fa781563f5df89a1e87adff631be4364c863e6f2e7b58765254f1" => :mojave
    sha256 "9cd0ee7b635aa40c7e8029d81e9ee5f330289a918a6bbf500fdfa75ff548bbfd" => :high_sierra
    sha256 "58e23a6b3c126cc2f1e4e488b2333810265de7496c30202b2f6b7e651866abc4" => :sierra
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
