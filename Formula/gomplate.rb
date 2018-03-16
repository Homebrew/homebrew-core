class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.4.0.tar.gz"
  sha256 "88e6d4a284db9e7cfceed44f1254da7c8802bfa4d19991847dce92da483c481f"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84a3ea4e1b6f789d2e29ff621dcbca95970f0ed55b980a60c9c0d8623f4da4f7" => :high_sierra
    sha256 "211a6bd1f86441678f1bfdc95188b3c4567fdf95f1099ca7151bda6f24c2e60a" => :sierra
    sha256 "7e9f3290aa3a4f0901867c755b1f1e7cb9a94302dcfb3079753f12c2bf59edec" => :el_capitan
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
