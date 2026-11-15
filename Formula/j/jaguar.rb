class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "1bdc3171854c9fadb8c70e6809fd88faa90e1c0cd25cdeef1e331e87c3cde3ba"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6af74950badc64f04f8b664f2e08279b2df6890048688595ec0a1dd6b6697237"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6af74950badc64f04f8b664f2e08279b2df6890048688595ec0a1dd6b6697237"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6af74950badc64f04f8b664f2e08279b2df6890048688595ec0a1dd6b6697237"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed5b17f2de9870904c601c62aa4ee0cebd11fd98bdc69c3db0ecfc4a3aa8600a"
    sha256 cellar: :any,                 x86_64_linux:      "de533d08baf9ded29eca33ed6be5b3156fa67d044b4fe22f2f5402df248b48f7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
