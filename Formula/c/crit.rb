class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "704d18b542370cb29e358091a0dc04bbfe8e26b717e5ed3f42ad13d9af8475f5"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3adf542bdd5c69abe4a0f16cc9efc93c2d1726a881ced42417ac5f3f2af6066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3adf542bdd5c69abe4a0f16cc9efc93c2d1726a881ced42417ac5f3f2af6066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3adf542bdd5c69abe4a0f16cc9efc93c2d1726a881ced42417ac5f3f2af6066"
    sha256 cellar: :any_skip_relocation, sonoma:        "5733f2fe1189046e5c590e009bf4bb04b3f949dada4ba913bfd7499ae27cf498"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "703eaf6b522376e00aca2b4bf89879dc49660029b42e4276be48bde72947dc2c"
    sha256 cellar: :any,                 x86_64_linux:  "aa2cb204a92daeeba277bdd61cefd50cf501217540b83e38b6b1a42587843484"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
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
