class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "0ccb9657ab15f69b4aa010e4fdd3569c3227e0ed96d46cee3cd6bf274614fa96"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48548e6aa439e2f48935e8ba942c3842941c9bc1ff587cb7a2645bb53607e329"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48548e6aa439e2f48935e8ba942c3842941c9bc1ff587cb7a2645bb53607e329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48548e6aa439e2f48935e8ba942c3842941c9bc1ff587cb7a2645bb53607e329"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "59563d542ac68052583ea314103a64244adeb08c3582e309aab4792cfb14512d"
    sha256 cellar: :any,                 x86_64_linux:      "ce272278eeff252e32ba7f2eebb6d17e3aa82b6b87d662ff5eb97f2cd2c68f98"
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
