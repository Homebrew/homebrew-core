class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "dd6660c6c38b03f35dc8644855e6f3cdcdc298ffbda1c1eb7c92eaa986132fba"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80d28fed15e762ccb1e501b00247c06697c334200f2f3c7ad7c134c46f57960d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d28fed15e762ccb1e501b00247c06697c334200f2f3c7ad7c134c46f57960d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d28fed15e762ccb1e501b00247c06697c334200f2f3c7ad7c134c46f57960d"
    sha256 cellar: :any_skip_relocation, sonoma:        "61288936071c3c451631ff71b2b4cc02e0c57862be7193c1c39e96205fc7a47f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7b38dac82bf380877c6edfeb884265c0f46b559ebc9e9be63dd15da0e8b59a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664857a258e8d4624a0f1cbf179de42073557abb65f1ef1a19d342b6e2381e17"
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
