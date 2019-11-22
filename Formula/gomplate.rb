class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.6.0.tar.gz"
  sha256 "b24c574a7646461911e5900a84c31b249abf65714cffb9c64d64e4b575751c74"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "667919ff17c4cf90ea26855f7a5c0ab1809c2d40a48fd0c8239369ec8a13fb69" => :catalina
    sha256 "32eda12648133f2e42d9d4a9698770078af69305dce8e8039859f628193e7fd1" => :mojave
    sha256 "965395ac9edc3e81b10b8cfdcc0313d4a61a14495873990a300ff13324d685dd" => :high_sierra
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
