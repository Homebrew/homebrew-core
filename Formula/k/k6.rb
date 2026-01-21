class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "215f25088ef4a6c52d18e8ee572149c880f1eabf312909e9e87faad5ffe3f00e"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a2899218ee6fb6cfbc5ed1c1f96da21edf476425129ca1c47b134e3a1dcc477"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a2899218ee6fb6cfbc5ed1c1f96da21edf476425129ca1c47b134e3a1dcc477"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a2899218ee6fb6cfbc5ed1c1f96da21edf476425129ca1c47b134e3a1dcc477"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2abc002d9fbb3f0d992a401a5af502be1afa36094c7275625ec844d6f54e31f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5afba1da2c9d522888f3ae81a3523c39555e2ebba8eca8920f93d0403f68c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3af63a4685b6c4213a80477f6e8d5121fcaa9c5ca19d5219fdc8c8a14818750"
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
