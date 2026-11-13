class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "34018ad7c49f52874beb355bd5b8f91bb997fc3697c59eb07b78ddbef077ef14"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "056d5814578c6146d12010f2e060ae7285e9d2a5ab4d9bcf7c4b8baa95a87110"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "056d5814578c6146d12010f2e060ae7285e9d2a5ab4d9bcf7c4b8baa95a87110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "056d5814578c6146d12010f2e060ae7285e9d2a5ab4d9bcf7c4b8baa95a87110"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9103a3563b3e1bc228a9a815c33aa28055c4384b7a0aa1d04a2255430beaf1a0"
    sha256 cellar: :any,                 x86_64_linux:      "03486c402f2261038cd1b0160047c48d83212ff8eba70e091cbba64597dbd4cf"
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
