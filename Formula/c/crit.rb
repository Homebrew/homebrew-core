class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "ad667b91f7ade11c0ac0a9527e7d099766f1a6f5cbcaec3344769c04afc957c1"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    manifest_sha256 "92e4e9232abeaec68a923a0278cb6ff29cccf3e5393252ce09eb4ba483348c0d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc073cb7dd2527548001321874fa7d56b3b87aaf104d8c6ac90cc8fa7e66f2a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc073cb7dd2527548001321874fa7d56b3b87aaf104d8c6ac90cc8fa7e66f2a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc073cb7dd2527548001321874fa7d56b3b87aaf104d8c6ac90cc8fa7e66f2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de62369aa25069189a9b837a692fd59b3677aac5e17f7d572f7411afdf54fae7"
    sha256 cellar: :any,                 x86_64_linux:      "afa11336e8c122a843eb1825636841b43cb13ca7779eb6584ff86ba3f4b295ea"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    build_date = time.iso8601[0, 10]
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{build_date}
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
