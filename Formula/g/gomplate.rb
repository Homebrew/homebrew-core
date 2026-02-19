class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "b4f24768c994dd62c95d7243cef4dc2354b47976fa8fbbda3889aeade8e39d69"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a8b1d45c8ff343326acad5cedda9425037baea7ffdccb76f760235edbfa91f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dc59a307bf5ef77948271d96f59d46221324029d10f191aa08dc2183fe2a301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e59718f32fe7b4ec17ddf76f251ff8b6685dec4c8cc0d2e03ec05a7f1697e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "423da3b81cb17fbd41d3aa735aa6eda7b0c6ea64e9db9c577252ddc7bf907ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92672fcbabdba54bf8e53d004b8bcb6c860c1e0b96837a05772864103a19dff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2063d2b9adec8f5c0afa3ad71a468298588bcf62eb3171a637204217019eab3"
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
