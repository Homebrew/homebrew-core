class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6a04403eea25fc721de3a7515b89301fb8679deb3faff5c9703d79d76e114fd9"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f86cb5aad5aa0b7406c4f4db0a36140a047adf838cef10b7cd4897bf99cedebc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86cb5aad5aa0b7406c4f4db0a36140a047adf838cef10b7cd4897bf99cedebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f86cb5aad5aa0b7406c4f4db0a36140a047adf838cef10b7cd4897bf99cedebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c56d6e521a984911201bc6a720be27c0484a7ca8c0063a486e587fdf4bb053dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d3c029192b3d1abb05271b2e182075b8e8785422fb37815d78a44abf31844a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
