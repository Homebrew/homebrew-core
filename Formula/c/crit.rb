class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "8499377fa662e3c97ce27a75dea5dbffbbf5d41929f5ce4304925b599cd00053"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6261d662487892fcefbee89622c61bde9936219c685bd8d3605efafcb708f170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6261d662487892fcefbee89622c61bde9936219c685bd8d3605efafcb708f170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6261d662487892fcefbee89622c61bde9936219c685bd8d3605efafcb708f170"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d44e725bdad46afea52df2440103097bb669989bdc950b0da0fe658b9f5a53b3"
    sha256 cellar: :any,                 x86_64_linux:  "b0091afdd89b9bb128f0ebcc7e6bf93d41afca144137fc12e6bcb21d885899f3"
  end

  depends_on "go" => :build

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
