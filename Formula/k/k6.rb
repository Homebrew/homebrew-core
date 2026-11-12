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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cd11b4fc89c72d6e711a2f8beca9140f720de2970d23d35f12e8a5362ff2bd6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7228c2394a74d6174596016cdbe20c3125a1c58c4f83a18a62b5600cd2b6d820"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26904d0e9e6260c94dfbd82c468e114276ef69c89b28e522f57cb88ab7570de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "685e64adc23770f166f7dd8da4420f4a0e3c210b7007ae845f228c912043c2b3"
    sha256 cellar: :any,                 x86_64_linux:      "042e8311f61d0a4a57dd71cc65470db5c987e4b6b49e899e9ce9369d703b394f"
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
