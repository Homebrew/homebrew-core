class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.11.1.tar.gz"
  sha256 "888f5ab1eda0ee26a3d7494f5fe4b10a64b3a519a559ba949019559dff17149e"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f65c21054772a56c08d71669295aeecf36bb6dc6acdebedc28553cd4dbaa456f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "babef0cba441db1c05fb827810fef12467c337b5572cf363a652adb24aa96282"
    sha256 cellar: :any_skip_relocation, monterey:       "a2369285f01e65fdf2683dc5e8c698878dbd8fe8b8d4d480ff9bfd6d2fcc45ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "a42e6a190774f8154581ddde1d13fa88880ade59e1b167c95cc0eec31e18c144"
    sha256 cellar: :any_skip_relocation, catalina:       "1de07bbe6799ef9506ba7a6d7e7efe81164bcadfa1c1828d2196125a132413e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3703f68a2d7c4598da6a0ec112ed38bb79a61073ffc161728721dd2e61895e9b"
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
