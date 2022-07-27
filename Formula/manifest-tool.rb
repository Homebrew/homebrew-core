class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "e7af6f7206e58dfaf4336169298a481de71c2e2b1dea457c17a241632ce2d9b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d9bcebc44d534b820503f879a743511dc7d5e93686cd49e6c1df49e4742e981"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a932de46a01d6ad46870c799d9b83e9084bdd5849925699a8b8299ddc2fe39c3"
    sha256 cellar: :any_skip_relocation, monterey:       "394160bd3c1344414711ae7c50898e0b936f9a6258f3b60a229dbd8ea2d19af4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c04d1da20bf4577be2a0759b9b21db918052513bd698e2f3032578066dfc1d06"
    sha256 cellar: :any_skip_relocation, catalina:       "81b13917fe55b2cf66b8bb3a4f158cfa3f7755c75f6e08b58c6f819159fc2e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b7009064fcc43d54309790bd3ebd63d6972a436255c8f29c43e910a98b4b444"
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
