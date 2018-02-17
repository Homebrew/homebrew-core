class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.3.0.tar.gz"
  sha256 "9a2280353504d7c68be97201180fcc7bea7fba00052c04d33bc9f350a7bbd6be"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b22752817ca0069062e2e0af0734c2a981d9299f62b510cf8172ae6f286b9c9f" => :high_sierra
    sha256 "095fc2e39b053844ad71bce61bb339a93b46892d469ed1abb4113ffd366494bd" => :sierra
    sha256 "adaceb340c8a6efaf8f32eafe64e32e581ba3bb4d3a361ca93c0bba06b3a7aff" => :el_capitan
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
