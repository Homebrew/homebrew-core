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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcc6cc8bf6d50a4461d07e6b7de577c0a104c03a1a43a7ab2b40105d3f8dd94f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcc6cc8bf6d50a4461d07e6b7de577c0a104c03a1a43a7ab2b40105d3f8dd94f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcc6cc8bf6d50a4461d07e6b7de577c0a104c03a1a43a7ab2b40105d3f8dd94f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe58254e4ea35a493ed922143504f6f561fa7bc0e0dfa1e6d201896fa80c7d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54013723cb961d9d85e7d85302eafcbb8d243f09812591755e8a3df08e958ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf80bd4287e346c8f5e8bde1547ebf941a06f646b133229ed577f95ce2865fc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", "completion")
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
