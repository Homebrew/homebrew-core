class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "909fa46defbfca664fd05779c7d60e099af87f877ffeea298497e95e3204983d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0fa16676503705b0b47fccd329f32d1dfe3ea713de3b5b169599c2dacb91d5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a26c70492d519db60390b6e1e23f9e955d8733094417a9ede31fe06a5cfbe53f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5e2ca74e8db7612d70d251517c2d6aadc57e114c0283e45b6c71b9e085a7709"
    sha256 cellar: :any_skip_relocation, sonoma:        "94779ecdde3e49fdb93412518e378f4375306b467e2d636b0b10940edfc21855"
    sha256 cellar: :any_skip_relocation, ventura:       "9ed20c11d7418c6a3a78679865e60d1e002a1e513578f4a5ac191992de1c3c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a289ef90b70bbdbdbab4d7dca57db966d2b3d5c3702f4744e2030267b4c08280"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    package = "busybox:latest"
    stdout, stderr, = Open3.capture3(
      bin/"manifest-tool", "inspect",
      package
    )

    if stderr.lines.grep(/429 Too Many Requests/).first
      print "Can't test against docker hub\n"
      print stderr.lines.join("\n")
    else
      assert_match package, stdout.lines.grep(/^Name:/).first
      assert_match "sha", stdout.lines.grep(/Digest:/).first
      assert_match "Platform:", stdout.lines.grep(/Platform:/).first
      assert_match "OS:", stdout.lines.grep(/OS:\s*linux/).first
      assert_match "Arch:", stdout.lines.grep(/Arch:\s*amd64/).first
    end

    assert_match version.to_s, shell_output("#{bin}/manifest-tool --version")
  end
end
