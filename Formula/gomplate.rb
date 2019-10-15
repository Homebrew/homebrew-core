class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.5.0.tar.gz"
  sha256 "9dc2ee1c5ffeb22ea564a63a2965db6f6778cd0f5eac8570e5b173370d603cca"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f46aba1f9c1fc835225a9a7a0ffb14daf5f9ec03bf10e24ee572fb21313e70d" => :catalina
    sha256 "ae54a129b8b3ad6addb9921c1c43135ad85f2f4967d354ac6d61df97175657a7" => :mojave
    sha256 "dd77e329d5f88b0ba0e2c008800c3b5d7be3a8bcaed8889240d6758aefd591e3" => :high_sierra
    sha256 "ffba0a7a878530c0daa37d2245e5ad8f998908413cae7d6a7f5bbcc4f7a4d401" => :sierra
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
