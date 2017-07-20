class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v1.10.0.tar.gz"
  sha256 "89537dd0f490f244c93539d716b2e67c30fb35c8800ee5a8d8e46ce29b19860d"
  head "https://github.com/hairyhenderson/gomplate.git"

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
    # Verify that we set the version correctly during the build.
    ver = shell_output "#{bin/"gomplate"} --version"
    assert_match "gomplate version #{version}", ver


    test_template = <<-TEMPLATE.unindent
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    TEMPLATE

    expected = <<-EXPECTED.unindent
      foo
      bar:baz
    EXPECTED

    assert_match expected, pipe_output(bin/"gomplate", test_template, 0)
  end
end
