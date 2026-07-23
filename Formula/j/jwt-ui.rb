class JwtUi < Formula
  desc "TUI for decoding and encoding JWT tokens"
  homepage "https://jwtui.cli.rs/"
  url "https://github.com/jwt-rs/jwt-ui/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "97c6a8cd998adcf80147aa12084efd5ca5bf2f0ead4645851837967d98114630"
  license "MIT"
  head "https://github.com/jwt-rs/jwt-ui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f118b3747b87b291d58ff6f174f0843defe9c1d955942b980a0a8c07e4836684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f8984bbb5f831ec64957ea03e78cc0537e301bac7a0672cc013cc52ace5874d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49f7cf23808fc2242360bf82951e0afe9f286049eea119048add9a744fc4d896"
    sha256 cellar: :any_skip_relocation, sonoma:        "5be6c791de416fa485fa427905a74cb9867ea92d6687599028f2253b1693dd7c"
    sha256 cellar: :any,                 arm64_linux:   "08da280300dbbe187e493da98dfcbf9982dcff3494bf9ed876d7b4a0b72a623a"
    sha256 cellar: :any,                 x86_64_linux:  "3df27285e33108b2889014d864f0f5743df6905cb2cd11950213deb8f8c360df"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jwtui --version")

    # Demo HS256 JWT with payload:
    # {
    #   "sub": "1234567890",
    #   "name": "John Doe",
    #   "iat": 1516239022
    # }
    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." \
            "eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ." \
            "SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

    output = shell_output("#{bin}/jwtui --stdout --no-verify --json #{token}")
    assert_equal "John Doe", JSON.parse(output)["payload"]["name"]
  end
end
