class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.8.0.tar.gz"
  sha256 "d32817821a7b083b0aeadf29c2aea17e3384b6b619f3a6285150db1914b94c89"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52cc95df2ec8d4a0c4f09ceaf3145161e435fc85106f4265ba24a5159f9019e9" => :catalina
    sha256 "e90c04a70f742766bd71ec4fc74c3aa7f6d5fcaf1147032ec52787e5bb326445" => :mojave
    sha256 "2fad9d3647034db30eaee6f556ba9930f8d448e287bdac70ad0b0cfa7332cf47" => :high_sierra
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
