class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "04d9a1586b23db9d1746aa61f29ae4aee4d2a5da7d5782e11f7530405b5f57ab"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39a76f7ad4f023a1260bc5cbfe40cf21cd4e4f02b8cfc20104f9996b802b8425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9312f13ca165d279a5248019c1d5060e8cdc2aa2ac907ea7a68049c39afebf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a42c5895905f155888cf5bf795d1d0cffa82951134219cc3b62593c20600d09"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c776c8d18acb1f00c04fb872a9b9a39de9911771826c13cca6c4c0c1d53c03c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac9c3edcfbd342e421b69b3120c7a0ffb2282b9d4ac0c388cf4d4d3443d1e5c9"
    sha256 cellar: :any,                 x86_64_linux:  "fcb55fc2302dd2d72dda12587af8729ee81ac5dede5acd3886ed4d0043f69e47"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

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
