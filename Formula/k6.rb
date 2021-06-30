class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.33.0.tar.gz"
  sha256 "c532013f302996e409ac4e4c73b053320f7581b101351fd3053ebcf2fc2a3e07"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "717b0f80625e33ef47a7d5f4a52dce79f42ed373fc3c62c157f5605ccd70bc30"
    sha256 cellar: :any_skip_relocation, big_sur:       "394913b3dd05fb77217b1c81340ad25d64a64b3d054cc9e8c6aa1d0465e5965f"
    sha256 cellar: :any_skip_relocation, catalina:      "f2a8d52cb9b8f53c509f092d0c81b9bc272161bc36a5cfe44e3ce4e5252c9e11"
    sha256 cellar: :any_skip_relocation, mojave:        "6cc8120f5db4d8becba48be80bcd98e90d2761651618e42a8f71473f4bf3a7a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
