class Pop < Formula
  desc "Send emails from your terminal"
  homepage "https://github.com/charmbracelet/pop"
  url "https://github.com/charmbracelet/pop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "360db66ff46cf6331b2851f53477b7bf3a49303b0b46aaacff3d6c1027bf3f40"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9daaf2bd102ae4cfa8ef52a81f956d5ec03b1554497c3c227605c2c75eb48d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9daaf2bd102ae4cfa8ef52a81f956d5ec03b1554497c3c227605c2c75eb48d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9daaf2bd102ae4cfa8ef52a81f956d5ec03b1554497c3c227605c2c75eb48d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3751ae162f97749c387f4b0962a231a2f70b616ab21e45396c1cb5a3049256c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43d251eab1371931673e69267d5e1efec1afec1f892cb88e35136d06d9dcfd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb612af3210b31359c2c083f7e72fd37663ea3c15c9de1f5e4ab06f46854e86"
  end

  depends_on "go" => :build

  # patch error status code, remove in next release
  patch do
    url "https://github.com/charmbracelet/pop/commit/65b34a366addd90a9d4da32ac8e5d22268ec16bd.patch?full_index=1"
    sha256 "386fda7d26240d5574b7f402595d01497d7c2d3254e6ad9276a8dd02de0513b7"
  end

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pop", shell_parameter_format: :cobra)
    (man1/"pop.1").write Utils.safe_popen_read(bin/"pop", "man")
  end

  test do
    assert_match "environment variable is required",
      shell_output("#{bin}/pop --body 'hi' --subject 'Hello'", 1).chomp

    assert_match version.to_s, shell_output("#{bin}/pop --version")
  end
end
