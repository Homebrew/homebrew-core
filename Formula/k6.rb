class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.43.0.tar.gz"
  sha256 "7476ffd41d9cb0c770b11509da7b7f783df811e9847e89294ebcd2a952aab0ac"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c2f49fba9dd5f0ae79e74466586919e1e47cc0174ad5e82e2dd7d0baaf945e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77969ef7cec7bf91dbf52584afcf0edd3a9cd0a28d18f57d5d9ad3e0c692c5ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "631ca4da67375a3e519853d2362a9b083a74fed939dfd74451718179f248970b"
    sha256 cellar: :any_skip_relocation, ventura:        "19cd86afa195a221f05d3e176e7d0a5304693a0c2091fe0088213e463e200557"
    sha256 cellar: :any_skip_relocation, monterey:       "e0d7532247b048e6729ff4e10581988fa7fb49716639952d139189d1a306a0ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "c80a49da56b1a50e7698c5efdb3c9beb1d17a6e17a3acda1ddab8a0bfa8e082a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0229d4479c12245019f301fca18fb5d69a20e3783cfeb587b6538235d2f0be35"
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
