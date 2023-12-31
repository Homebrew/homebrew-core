class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "74937119430d24397684003f0d4ba30f3e362742caecf3e574e968a3623df83e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "972f649a148a6e66d5e374c50a509c680095b9d696203923bead2d6ae67077ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f91ab0e5516d8b450aa4a9904e9885b87d4c4b93579d7942ac9e74c33cd9a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad4fe4953a40c829a4acd709e4b5be891aa54b94fe61a42a0c7fdca6549a8413"
    sha256 cellar: :any_skip_relocation, sonoma:         "584b0fc7b7ecd8a152d7153aad637a238a7891a08ace00c3b82ebe17d2604b74"
    sha256 cellar: :any_skip_relocation, ventura:        "1820d87341c1291b79533db8ba0b052ad3cc8074e1dc163a485351342e959972"
    sha256 cellar: :any_skip_relocation, monterey:       "a03ae205258645b02bc4c859778c41fe336c9152f2a40c00a1a77026877afcb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20119b02d73f800092dc51254da3cf2a6d763ae5243063f893ae105f084fdd6c"
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
