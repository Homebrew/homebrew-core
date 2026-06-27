class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.71.0.tar.gz"
  sha256 "a078e297eb4f13df969f15133bf628e79f545e7dcb04a82a16c4ce8d6ebc514f"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25f62ad51bfcc439ca5bea7c822ddd62bfc21f1b86ef7d7aade4603ba83b6dc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b35ae21a03cc559c646d93856b88f019950862f3bab53387afd6eebc45324d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e99fb974744c54dc021c7c8a09b95a5b398de171d965960a5ea1213a1d0644a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1289655024c027769e5ec0b9399f072a7bfb779da5b8c3d15a060c1ba7a1a52"
    sha256 cellar: :any,                 arm64_linux:   "29a587bec1fab9eb8eaab28301c71686e99c7ff8ad45cca94fadf7f47316bbf9"
    sha256 cellar: :any,                 x86_64_linux:  "3f761ebde838bf129eeca426effa103a6a78cdf645850711617ff23701567f13"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
