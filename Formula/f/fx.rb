class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/37.0.1.tar.gz"
  sha256 "1d81db387d804c43368f6f85c760242814da07363a15b329e8ff8d369b343e8a"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e5b7c64e483a8626427d0f141545b7d5f29bc4242ba70df7d128ebeb47d3a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67e5b7c64e483a8626427d0f141545b7d5f29bc4242ba70df7d128ebeb47d3a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67e5b7c64e483a8626427d0f141545b7d5f29bc4242ba70df7d128ebeb47d3a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b10ba4ab18a273fbc8b8c67dc16c1b70316bb93fa8674e2cf3c0dc014c6a6dcf"
    sha256 cellar: :any_skip_relocation, ventura:       "b10ba4ab18a273fbc8b8c67dc16c1b70316bb93fa8674e2cf3c0dc014c6a6dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "340eed05e41b78e16a15f572a8e337c5b19f18931aa93590d5a76a2b5e68dc46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
