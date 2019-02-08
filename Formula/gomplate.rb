class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.2.0.tar.gz"
  sha256 "52663592a5fd1a67a8c48ebd434860e1930fe3b9cab2c740bef7629177f932ba"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fcf8a34b052ee4886f9d9807533592580be6dae5c8de4a393749191f9bf5f68" => :mojave
    sha256 "a8a660307bc86dec5f1ca64b4340ce0f2214dd15a58f64c1f6fe77abd6cec74e" => :high_sierra
    sha256 "f6bc660bc410341a280728fc167f66623ae830be8ef7a44c9512e867e57e0114" => :sierra
    sha256 "1b676e87e11d083f391a0198df5c6d582931ceb7272d006969f1ac0dbc28cff9" => :el_capitan
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
