class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "fe017755f9e1939a5a880fd89230bdf342170b340e72052019bfa34d50cabe88"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "661fab3e95cc2a4f673c14f01eb9a89f718aa1b55d1739b625e9254ed6673023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661fab3e95cc2a4f673c14f01eb9a89f718aa1b55d1739b625e9254ed6673023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "661fab3e95cc2a4f673c14f01eb9a89f718aa1b55d1739b625e9254ed6673023"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b149165986109b4723976b01b7ac0f3ccaaea0ab3b98d057c4fa0e277a3209c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74dff7a4b763666524a6de6e602dea11de7cc2e546ea99baa25134a63a4810b3"
    sha256 cellar: :any,                 x86_64_linux:  "3f9efd3fe316b9d327de5dcf43ae3ee89ef10ac20489d0c6006954f45222fdb7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    ENV["HOME"] = testpath
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    review = (testpath/".crit/review.json").read
    assert_match "looks good", review
    assert_match "hello.md", review
  end
end
