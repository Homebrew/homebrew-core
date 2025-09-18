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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b58508f75f9246edc00686759e9f5e6742830fd426225438d7426f3b42bc7579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a8700eac00d73546e47d3e0b0d0dd30de1dd196a74e34c0a155501cef6e180b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe5d9228796ed7b924946237b59ecaf33082c9fe243e58db17d1a00d401f3e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "592498b49bf2e7f61dbc0dfc7d1ba6fac6b36858f145eaf3a70802d11a423267"
    sha256 cellar: :any_skip_relocation, sonoma:        "3128c00339ee05d26a06b47da27f321a52413e37debb95ac25932b33d80128ae"
    sha256 cellar: :any_skip_relocation, ventura:       "76525c040ca5b17f378711daf85d414221f794e4d4ca2c564ab3366fa2ab21f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21242f12dca5069200cd7c671fc5c595785dfcf5f86443fccf9e17465aaf83ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90a09f23e144ae6acad537a85cf735435aa1e4fc46ef33703e965c55c0616c96"
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
