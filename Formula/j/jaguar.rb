class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "de517d8cf7e72d0a7fecac0bd92195c64fcff21a61068108d28be2897793e913"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "052d2191a1930bed135c64cc941a681def651b5599eca57f0e73f7c25dbb0256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "052d2191a1930bed135c64cc941a681def651b5599eca57f0e73f7c25dbb0256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052d2191a1930bed135c64cc941a681def651b5599eca57f0e73f7c25dbb0256"
    sha256 cellar: :any_skip_relocation, sonoma:        "48e79a854a007f850ae16922a17b423cd998bd81521f7d8cbd0507b834d58442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cffa974d635a99967a90fe7ebaaac6b39743bdc44919d4e34cc4367704e4f690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828977b045bff85dea4c372787de2bfe3b7d7645ee177a4bd52f0fce180da664"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:\t v#{version}", shell_output("#{bin}/jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output("#{bin}/jag run #{testpath}/hello.toit 2>&1", 1)
  end
end
