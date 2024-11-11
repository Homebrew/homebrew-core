class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "3f7c58978a4fb8944223018a5da7cb664ad9864206f4a1ba469619e1b5c74992"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb9c5ab71cf2fd5d5f6deea7ba320d5f429391a85b779acabc5ab3e87b04e94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db2259686c2904f34e45ef21af0114d3207337c867aeeee3c8810786eb0fec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e94a2ded3df4a5d60447ecf7d506056440398b690062ba124f87dce9dd36294"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7bcc3459cf7308e8b9de218159da76e2e7c0d98622f2e3b9cd8396804c8eee"
    sha256 cellar: :any_skip_relocation, ventura:       "88b3460f516fbaa64310fb9c98c64387b395f82bb011f6898b50c5bb171426f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de57bdfb52abc7f90a929f8b73c120cf0e4e8123ee7198c140f71990c5ff9137"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
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

    assert_match expected, pipe_output(bin/"gomplate", test_template, 0)
  end
end
