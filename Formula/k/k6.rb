class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "0eb3c64b3debee94d46a19ae895c10de6385b5f4b2a2c24956d49aabc1808bd1"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82ccb68823ed6e17fd3ffb7a520429b0fc0210e6882457327eca042960272512"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "869e7fa78d5d9fb284fc87fc3cb0f926cba1b94caefebf3f18bdea2912594c19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfa8c2665a2282ff3589a780fd2278bcb1c8de616bd544a834bccfddcf02d1bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ab256c3d4843662455f9fdcabc5f86bf7f9a4f94c2ccea3522631b7040a5d44"
    sha256 cellar: :any,                 x86_64_linux:      "71207b1cbccfcf410c4a28839208f6751e7dda36fe649b6be8932de85b62b3a3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"k6", shell_parameter_format: :cobra)
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
