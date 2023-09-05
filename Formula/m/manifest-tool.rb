class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "c493f15cf3770aa2873fabe47baf2bbc33622f27b7b5c8dfcaa2cd91ee7369dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc4ea6d13e82b626ed17165cc0c009a8d3fe06dffeb6e4c5e15eca53ad9ce76c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebf54bd973a897d656bbde4c683ddc172dccaa4af8a05a67890778ebca5b479d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "414754127e200161b8b2f00d723216f118a1f12f4964d2410c1fe027681f8d05"
    sha256 cellar: :any_skip_relocation, ventura:        "57b127352c3b9380459d52ec0702dbf33f9c50ea38859662837cc95718237903"
    sha256 cellar: :any_skip_relocation, monterey:       "9449be36a5e3a9ce57e5914602875afd87e8b554a1ff302e214c34d600240a27"
    sha256 cellar: :any_skip_relocation, big_sur:        "a62793822e75153020ef4594f534db870445d16825f2fae61441536b753eb1d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "218360f98e9b659a2f636860c0de8507a72fd5ac7ce26f1671be09d1cd0ad11f"
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
