class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.11.1.tar.gz"
  sha256 "888f5ab1eda0ee26a3d7494f5fe4b10a64b3a519a559ba949019559dff17149e"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbaa7a423653935a5da14f8d179f1c508f24448fe1796f440a25bdabe799b06c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecc85bf3e98ae28b55930e49396bdd9256050d836d5248986687b70264353d33"
    sha256 cellar: :any_skip_relocation, monterey:       "6c0b74eb0edac99cd389119bf96643109253a0a284a95992d3916423b467f71e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c790639fd07c9238be390566670b8dba96e336420268594d7e6703c4c700212a"
    sha256 cellar: :any_skip_relocation, catalina:       "f491a7be3e1416759f2a56f6589e098a489b0d01dbad56e33f0498152e9fba53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6e50e183b35a604d7544ca9ab6d996e8bb33911b4e0580df061f83efd1abf4e"
  end

  depends_on "go" => :build

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
