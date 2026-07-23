class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "243a17b5493532baa110ed78ac705a3746044b0fd90fab2943d7be5affdcbd16"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5ba810733e453fdd3975411bbeb66f42cc0610826aec9d1ed6d256b62b60f39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ba810733e453fdd3975411bbeb66f42cc0610826aec9d1ed6d256b62b60f39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ba810733e453fdd3975411bbeb66f42cc0610826aec9d1ed6d256b62b60f39"
    sha256 cellar: :any_skip_relocation, sonoma:        "88a6510fe47520e4ae67d171ce1ea80f205188808c20a1903fafb47bd9e119b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23254efe324ae0581be7ffaba70b5dd97e28b1f31bcd444ae6cec77d2df48f7a"
    sha256 cellar: :any,                 x86_64_linux:  "b018c921bbd29df7d06be7fa222ea61fd6faebd33c1e7d11fc1fe6f41b74c4e7"
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
