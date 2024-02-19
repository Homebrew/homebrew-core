class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "e70454fe93e1e519bf2a1b0d185894f7550e5e2f5b1a48ba781de41091988c21"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4039991f72347a7ff3375b2e5a0da45af67b7d8e701d802afdaddafc025c2ebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3da0bbefacd8920fbadc43a32a0cff697a25d0a7695f4b29233079f0803a31f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcb19b22a13ed2984ac86fcd5348132cbc0044a8fa975978c55a7328c5bc0961"
    sha256 cellar: :any_skip_relocation, sonoma:         "892981cbe6931f4da52634cacf66c76eea97d4d7c165e93f72183c89b3cd0eaa"
    sha256 cellar: :any_skip_relocation, ventura:        "7574f75c1dadf8544f733f8fc6e8665ebfdd7ea3392e24241bc6409e8127603a"
    sha256 cellar: :any_skip_relocation, monterey:       "7f220d721806a809f4efb52587e0ae3649a88175daf0f0bb2622a027229f925b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac3c5294221bf374518add84778aa68b83d914174295a2ae1a3e5f021afb4f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
