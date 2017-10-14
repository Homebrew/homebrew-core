class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.1.0.tar.gz"
  sha256 "812b8f25a905c157f48b38a841962724773e420a6691db5e974b2b6de0b4e3bb"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a47dcde00073a1118c875e4088792c3ae1e229cfe22a3ecf9b536870ff9d679f" => :high_sierra
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
