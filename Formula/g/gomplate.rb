class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "d15c66230d72bdc13b0155f28d391c55cac45b7fdbe1ff4a73db8ee263471a3d"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbaa6caf97a3f94c4b014ce4c6e0d720bd6f7715ce43513953bba7176a7e4fff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58161dc9a49352c77dde2e9acff85ebcdf521a78bae12431df7ab101dd83b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e37058dac0080cb1b43968d727a4bdbeac883622eb7a8ba109eb12d687bd23"
    sha256 cellar: :any_skip_relocation, sonoma:        "34b3e415c42373b54fd1d20df9fcf470052ccd0163c95036b876b38aebc4dc04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a49359096e1e5874d612ba6aaeaf97bd7315798ed9a9ab07e624697ed0f7f0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666de4e8f6ff9c36e5eb969230fea96f352505abba53deb490305c7a1ac60c1a"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
    generate_completions_from_executable(bin/"gomplate", shell_parameter_format: :cobra)
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
