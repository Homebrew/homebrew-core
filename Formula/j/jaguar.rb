class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "716b61cd32e6759352fc41021e91fbc56e23b0960bb61d88b70253a55392308c"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "beafc9def8c6e8196fc4782e42cb9187c64f6464a17552696efcc9328a5a4397"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "beafc9def8c6e8196fc4782e42cb9187c64f6464a17552696efcc9328a5a4397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "beafc9def8c6e8196fc4782e42cb9187c64f6464a17552696efcc9328a5a4397"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fdff8db3a7b7f9f40f9548eba09661882de70f35275f3317854282f5dc3f0d8"
    sha256 cellar: :any,                 x86_64_linux:      "bfd08eb67fa8d99cf969f780647cf997aaf5451a0cbe3bdfbaccde4a8e2624cd"
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
