class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "1f653584c4b8a191474a55a8f2a1ae661b82c6e7e90e243cf27969eb21ee8453"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16d9d5cdc4f7c2a0e2420affbf03a30d8f40f7179069ee636a92dfba1e466ae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d9d5cdc4f7c2a0e2420affbf03a30d8f40f7179069ee636a92dfba1e466ae4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d9d5cdc4f7c2a0e2420affbf03a30d8f40f7179069ee636a92dfba1e466ae4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e87e08d199ee6ab373625095ffc95f50cb56570465826f3374aec5a28220094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c9268001ac3541a3b3448401fc6c1d3e851473c91145e5ef437b54964dbfe69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b39f62d3763e6462dcd0721dbd84393e5c933d62be984e6253c1b5f378b2bc"
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
