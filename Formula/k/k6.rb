class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "c7dee72fc5fe54c3230fb5cdd67e9b9668bd98784cde057a92294fc2093a45aa"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f0af69503fbe5bfba9e93d54c3504046958b6c15cf52cc6063ee7f3de73042a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2877060a2cf3b74c302b76aba662447c7552548281fa0f11ac6d58168e62c902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095d432c2d7a53ad48683cff439db812500cf3854bb5cb46e5ae53aa3f030531"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1c624789041f7d83279e66f1de11dd912befeae8eca58d404f9804e3277c89a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f232e4b6c9ec1ee0e79e7f4d47f19d324722197111df14574945f770f77ed7"
    sha256 cellar: :any,                 x86_64_linux:  "03d8262d32365f51f60996f4791ec31fadd784653adac999831bd752ba40f270"
  end

  depends_on "go" => :build

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
