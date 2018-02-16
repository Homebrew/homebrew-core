class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.3.0.tar.gz"
  sha256 "9a2280353504d7c68be97201180fcc7bea7fba00052c04d33bc9f350a7bbd6be"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d732f96acaaa00080c3e7773f467e869c643b4d574f61ae1f400aa7337316ea3" => :high_sierra
    sha256 "e376922fcab28ff7ccc36e7c1dbcf0bb61a8a8773238a75e439f7347b9c86e35" => :sierra
    sha256 "97431363f058b41d7cc23d61920276b6c2bda572fe235d3f2ecabb3baa6c3a4a" => :el_capitan
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
