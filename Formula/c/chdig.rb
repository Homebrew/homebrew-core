class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.4.3.tar.gz"
  sha256 "73395ded1179edd960439d72f18c50abe93a4cbc3bdf0fc976371378ebc0fc76"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "211db455b144b682d3a0c53dbc6c7f2fbd9d75a6df1650aff163be829af8ca87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dadf53a3185e4a7bc225a06c8ca2c59aa5e3a60609d0040ade2821fd76af5f6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fb3655624236a7b217b595083e7d3338e6a3278ec84c08c12aadd5beed7c23c"
    sha256 cellar: :any_skip_relocation, sonoma:        "66bbbea7b4e2cbc70d087a2732aff43a8f389623e4ef874d6b9d2e482efec892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52ac760737cf3057274b17dd962abf98bec9c3279bb3362dcf9dbd334fc7d3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c97b29ea545ddf5ca5eb23dd6600353409dda886cac41e4f0b38f57acd3d17f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
