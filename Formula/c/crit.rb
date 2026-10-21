class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "4b1c0f9835f752ac07014ef306a60051f4fb1839f1911f8916eceff0938f2383"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cec749b028b78ab789b71c5ff2c08fb422cd9790707644cc9cc5c46c62d169df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cec749b028b78ab789b71c5ff2c08fb422cd9790707644cc9cc5c46c62d169df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cec749b028b78ab789b71c5ff2c08fb422cd9790707644cc9cc5c46c62d169df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ff3798b9eede8cd1cddaedfe5d6ae7e08a44780a7aa1766b920a5f795c58e78"
    sha256 cellar: :any,                 x86_64_linux:      "958bdb471982328aac4896b2f86f78a2c2425fb558be9e95e78995e977087b4f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end
