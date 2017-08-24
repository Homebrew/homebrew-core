class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.0.0.tar.gz"
  sha256 "ddc2c6e5b2bc4e2cf75bbabf1a28da85a20f35007f38c1685741b44d227c5df4"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05645db690ebe754a1af90a0151254d8b945a69f28c4dd24458716767ae417a2" => :sierra
    sha256 "a95e04ae37e15d509f141dc6f4155c216a756440bd1291275d533783b6c5b0cb" => :el_capitan
    sha256 "f2aebeda4abbcd3f7ceb6c44807dbb3015de24dcef8f7e6f0d6082ff62b51ee4" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "upx" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
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

    test_template = <<-TEMPLATE.unindent
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    TEMPLATE

    expected = <<-EXPECTED.unindent
      foo
      bar:baz
    EXPECTED

    assert_match expected, pipe_output("#{bin}/gomplate", test_template, 0)
  end
end
