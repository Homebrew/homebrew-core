class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "706089f6dd65b8e50cee71ac30d32b44be8ddb6c65acf8ff54b6a0729027148e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73a9a995faad7ddc2160f2c8a182b426bd7858700e7eb04a310e9f146ee0f6d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73a9a995faad7ddc2160f2c8a182b426bd7858700e7eb04a310e9f146ee0f6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73a9a995faad7ddc2160f2c8a182b426bd7858700e7eb04a310e9f146ee0f6d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "60e04bb0685c4ef6be3eaff90c41963c3684b09bc6e0fc5dfa365cc3d0150f2c"
    sha256 cellar: :any_skip_relocation, ventura:       "60e04bb0685c4ef6be3eaff90c41963c3684b09bc6e0fc5dfa365cc3d0150f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42373ffe97390f22e601a1953a55b682a74b38dd4c001a2fe295124ef1e6ab7d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
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
