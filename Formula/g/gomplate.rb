class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "1e8b68867aab4831828dbf4a3f5065464d7b062d7f058d5143519f3720ccb53d"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a4704b43e4ec20db4a5fc5b06ae2660af4dd26abeae4103c22db8da6248872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc96ac6fb09f0c958296792b336887ae02ed9b86f3a211da762de2f331ca878"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a75b3f72bd8d7106abdfe01a9e860fd585f2032a68b78d555498160dbdeac560"
    sha256 cellar: :any_skip_relocation, sonoma:        "75ec966691ad4d334ab6f4e57731acde2049579517e4ac7c465b144ed6238c38"
    sha256 cellar: :any_skip_relocation, ventura:       "c1c880e958c8bc749dc95521a29d550951de3c22944476d167437b2a181069c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea09ed4f72efbf5e0ecd6fd15d0da50c0b7ee3e4add2db5752ce69c82f1c3f9a"
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
