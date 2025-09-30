class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "e0496cb61210b525cc2be324872661f5132f3b16a350f066dff8a9ee23685443"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca3b1852310dfb19127e989b0ae15a51bcf9b7673ddccdbef2ac926eb6a0e747"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa4b1ef31678f6af8c4e8dd8823bb4028c9331d62f5fabd10ba36520ca90e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fa4b1ef31678f6af8c4e8dd8823bb4028c9331d62f5fabd10ba36520ca90e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fa4b1ef31678f6af8c4e8dd8823bb4028c9331d62f5fabd10ba36520ca90e17"
    sha256 cellar: :any_skip_relocation, sonoma:        "b390115074a3f098dfc5f00ebc449fec8e362b5c715bcb48a7e323263e83441a"
    sha256 cellar: :any_skip_relocation, ventura:       "b390115074a3f098dfc5f00ebc449fec8e362b5c715bcb48a7e323263e83441a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c02b0da12e2f437abdd825ec3f06093959e5b22419bf216a2c070e33bc8df1"
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
