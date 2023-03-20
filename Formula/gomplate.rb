class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.11.4.tar.gz"
  sha256 "03d2ca995ec470293cbf7446c8f6a79b2a9fa8943fb51025139dca7810f1431b"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a12b8b85ece0c764f5e485f6d6c26842e6416ca61e772eb9cd0b82b7bb90b09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7112808f0a406027e02b1eb397c4c0ff6787e2ee9f68781f220eec0acddfc5ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f7e5bf4e612bebf5a6969e7c2702f21ebd247feb68ae4884b64d6543890f014"
    sha256 cellar: :any_skip_relocation, ventura:        "cbe982a7167cb3a53bb836b0b63dbf89156a7fb126a0e0012c8eb5deed49fec4"
    sha256 cellar: :any_skip_relocation, monterey:       "42167eeb85476b4a4f2664e6a91ba20e98cc091d2d9778f9fe0f90567338b8ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac80e544f63db96c8a2dccbebb90af44e9f17276d27af7be6446e5a83394c972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "621a2a033543fc50ce3ad023d16b1d36949e6acc611ecfe9aeef3c75f9c04217"
  end

  # upstream issue report, https://github.com/hairyhenderson/gomplate/issues/1614
  # update to use go@1.20 when the issue is resolved
  depends_on "go@1.19" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
    prefix.install_metafiles
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
