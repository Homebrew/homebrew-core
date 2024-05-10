class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.11.tar.gz"
  sha256 "29e11bfc4f313bcd4f4c8fcb58921b8e4b98ba4570f7b0c85e0e360d9685cd00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abd799ca6f2e0f90f34881c9ec3cbce519c0cc853163de3fe282ddbbc88de603"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89b7dce67623bf42209f8e3aae2a83446dd7e11a5ac14c726b8449b83f6f7453"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ecd20a56bf02811d6a4d87df794fbba82c70d31e83b4b4cc8348e93d987c3bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "52a1a2ada448a623dcee5374defbb9e67cd43054b4c5c5e416de640f4cac0232"
    sha256 cellar: :any_skip_relocation, ventura:        "980fec75c8180a12c5ac625182f9536368aca2b604a1aea82fa72df557b3e903"
    sha256 cellar: :any_skip_relocation, monterey:       "1dfdda36c242e9f9434371e1c6c15ff6e42f0d854d564919aaeb9bd86eab28f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9bb7a535e310d0a7ea72913de01ee5a3297d08d7b7caddcf40bd4d6e6f0ed6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
