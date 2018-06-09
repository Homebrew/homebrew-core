class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.6.0.tar.gz"
  sha256 "6376e1eb1cf0eb9d452181361e69c99a6e28604cd986a1b3580cc7e58aa7c578"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c7af9f63ec3d48585e5fc95e801fa6736f69100bfac373df50831ce83de8690" => :high_sierra
    sha256 "0bd537a44e88c9ceacd996c12a91d71b0730098ef4dbeecb99663e448bc07aeb" => :sierra
    sha256 "e3373701d53420100fa9220ccbdf7f4c8e38a8cba84d2f41fd4bd5d804908e18" => :el_capitan
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
