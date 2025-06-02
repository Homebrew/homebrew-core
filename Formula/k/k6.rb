class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "790e8a1d1171262095edbd5df5a74f18406d11ea88098560d0f18b7614c8b880"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38ad23f362dcc33ac2b99cc9c5c50a2f8bd46bea7bd79ca32818584f381776b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38ad23f362dcc33ac2b99cc9c5c50a2f8bd46bea7bd79ca32818584f381776b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38ad23f362dcc33ac2b99cc9c5c50a2f8bd46bea7bd79ca32818584f381776b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf258efa6b268478028b8e1cf2bdc902dafb3d32079fb47602897256a74b72cb"
    sha256 cellar: :any_skip_relocation, ventura:       "cf258efa6b268478028b8e1cf2bdc902dafb3d32079fb47602897256a74b72cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23290c9ad12400f796b7a0028190c78938b932610204c3d7d33ad1002850610"
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
