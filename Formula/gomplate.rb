class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.7.0.tar.gz"
  sha256 "c9be7f326cba2232bddec9c37ca77f111539e8157fc2cc0907c5815cb86e5dd9"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e32419b8da7092529c86f39741f0afb2d49d50f07a4f71ebb77827a220c8215" => :high_sierra
    sha256 "f42240ed1765268e2c0572b3d9381d4626526c4010254990fd5276d5790d9f97" => :sierra
    sha256 "ba76db93115aa4bd620ac7d7955b755c5a0b3e0bfd20b793301349bc43d5af99" => :el_capitan
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
