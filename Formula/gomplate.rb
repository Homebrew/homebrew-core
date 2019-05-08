class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.4.1.tar.gz"
  sha256 "900efefc9691bdccd46f77cec43f74066709c5be60364ffb160bc76658a97313"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "488210a29d2f2fbd9113ae29d60869fc7e057e868eb46f16771aac7f7ac1c20e" => :mojave
    sha256 "540010c7886dbcf8306bc09664b02d18e97d9ff0f5e7fb02e9de44de05962b91" => :high_sierra
    sha256 "71d912d54b3dab2ae8a27a53061620658d1b5a99f31c37c57b1ea8b9d89c942a" => :sierra
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
