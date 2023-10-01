class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.46.0.tar.gz"
  sha256 "8f3c7ddc9e4df1c6df745be9ca0dcc81188783afac76c8bb45c16a2079299c63"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edb91f0c421caf0f70e28614e5853d6547f9dd62898a4ef055827b390e6e0efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af0378d95ad7f11dd74b596d974b86d7bd499c8e05262961c46d06eb796c6d4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a35ca279a43d0f8869b2f569c14738fca1d7e5f1e6e9fc6900f548d5dfc3ab54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd2540b62a6321485e0f961c26e8a6c7ebaa23bffbd953e9b2b72630cb454831"
    sha256 cellar: :any_skip_relocation, sonoma:         "afad3acc4ef06812f05d6a85604354e11fcff87a446ce51fd6468bf99b6a9139"
    sha256 cellar: :any_skip_relocation, ventura:        "71bc97676e8ba0d170609a022e6f35c822d855c6b44102efbdc5821f810939fa"
    sha256 cellar: :any_skip_relocation, monterey:       "efd38624cfba87dfd98014403ea2e30fd8c0c18356326beac7924102b5206d9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6227006a0723f5c009dae9ae0f357c4d55a6bcd40ebe98f9d5bb226569ccc7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "205e5faa1c0412d08c240d3786be0aef28c6b9ca41fa2581d198663c44e2a9ad"
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
