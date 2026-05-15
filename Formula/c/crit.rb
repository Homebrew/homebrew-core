class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "48f5b4426af65d11b172f03f166bb63302836a1134b3a935f2d2f86f59e27dd2"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "269d25f53e4a10b7868e88f8afe851a7209238d02be7cdbfb3439db8a023834c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "269d25f53e4a10b7868e88f8afe851a7209238d02be7cdbfb3439db8a023834c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "269d25f53e4a10b7868e88f8afe851a7209238d02be7cdbfb3439db8a023834c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea2eebbf8701e11cb8813289687fff16417607765272191d63094bc7b5fc8699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a4506a733f3bd1ddfb43e20d6320dd84675c3fb81594efa7e71df2093010146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2111d04d38f5fb26133f808d7576713a0f7716594bb412c5869ea6a12118dfab"
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
