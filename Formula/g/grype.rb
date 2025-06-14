class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.94.0.tar.gz"
  sha256 "d285dc8990f4ab5f8620858fbf4831520526cd8c705ebdf9c9c2cac63745d380"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a1f06d68760f15a943cc33c6cc34ef1531db751ce1963a8ffd8f86fcc434842"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "606d89c11227c269c2d236d67d5df6a6f89c1ddb143b204a618834957fb23b1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e7df5fbdbaa2ec33860edb7b0c5d92300473b46282a5689885606b13b684bad"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed6b31b5285cae8e9c22eb243d09205655d1d8a2c6c5890793fead4ea84d329e"
    sha256 cellar: :any_skip_relocation, ventura:       "bbcdb9b7b548b40bfe93f4fb09117e9d8daece7dcc17f944c8643c22722c75bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81dd07fac92e291adc62e8f81c66a6427d2ed5a3a3f8dde6369038e38b88bc8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aabd3e33fbeced60e5dc9104e918722e1804205393025cc218217859f66b2660"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
