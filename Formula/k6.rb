class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.32.0.tar.gz"
  sha256 "a13dcbbd15a0d6788be7cf2f25796ae6ee693cdb5b573e646bc54dc37b1686c4"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3f9c76c386521e7d27b2703e25d3b327b770f8b7f10bebeb934ad1f41cf6aac"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fbe31dd70a66df0c6b7fb438c5062e533426292f979f28c8fd521bcb6d430fe"
    sha256 cellar: :any_skip_relocation, catalina:      "e3a8be0eb13893be9f7c5ee90da5f1e4b3b4d988eaf50fcaeaacf540df047e08"
    sha256 cellar: :any_skip_relocation, mojave:        "080495ac7d5c9d19fd3a55d9f383411fdc3c1dee73d63443122c308da99ac04c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
