class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "86277c652d1568807a61236d1565bbe8b2280be4f11a6075a03cd7581469d355"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18c5d617a076539f22870d5d60b6c85558c4a5f31b16705c88edfdf3dd0e391e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18c5d617a076539f22870d5d60b6c85558c4a5f31b16705c88edfdf3dd0e391e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18c5d617a076539f22870d5d60b6c85558c4a5f31b16705c88edfdf3dd0e391e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7f103b11f01c5a51d1638c8526d20c1c2351565128b416454fe03089c39bf70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eb0193999c960d570c445f9aae87bf5bcd436c0ceb623b476bbdbee59e9e5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04ab0160ca18db185916115691b6e9161988b0084d2a9ee235aae2a47fdce353"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
