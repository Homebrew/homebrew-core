class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.0.1.tar.gz"
  sha256 "298da5c8cccb7123cc8d07a08f47386e25e1c6ada92da69acfaee2dff0173084"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9d5d3e1b513eaf309ab53be77199f52bf0f96e37f51c3976ab52396039ef275" => :sierra
    sha256 "cbe5d1beb5f39287209382c9b04c0af48188dcbddeeb5cbb8192c92301d062d4" => :el_capitan
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
