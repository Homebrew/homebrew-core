class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "245e3864fcdf2f82eafd7878a38f57e43065324fd7709332e2b8544af8f1f131"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "949f03601713f51045079d34ba13f5e87427a3fe20eb3f89aec856a9e10549d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "949f03601713f51045079d34ba13f5e87427a3fe20eb3f89aec856a9e10549d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "949f03601713f51045079d34ba13f5e87427a3fe20eb3f89aec856a9e10549d0"
    sha256 cellar: :any_skip_relocation, ventura:        "405a9d63531ad296e95034410fcefeb3424dba9e102e85309bc4451637939439"
    sha256 cellar: :any_skip_relocation, monterey:       "405a9d63531ad296e95034410fcefeb3424dba9e102e85309bc4451637939439"
    sha256 cellar: :any_skip_relocation, big_sur:        "405a9d63531ad296e95034410fcefeb3424dba9e102e85309bc4451637939439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d982cd916485fb896088f6d0b81a4c727fa8acc4ef07d9ccb8438b7cc9b8fe0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
