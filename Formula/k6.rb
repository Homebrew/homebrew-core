class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.43.1.tar.gz"
  sha256 "fa1c8257046ee22fe7896079b393b27e55af767e44a4489f8977a7755acf7c53"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de964bfa3c8cdc676305d0295a28fdefce413796f012adea10a0629c5c7d58cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de964bfa3c8cdc676305d0295a28fdefce413796f012adea10a0629c5c7d58cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de964bfa3c8cdc676305d0295a28fdefce413796f012adea10a0629c5c7d58cf"
    sha256 cellar: :any_skip_relocation, ventura:        "bbfa5e18d23a7f84a051c9573f05e4b602929c5dd759a1151f8ab14082f39f14"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfa5e18d23a7f84a051c9573f05e4b602929c5dd759a1151f8ab14082f39f14"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbfa5e18d23a7f84a051c9573f05e4b602929c5dd759a1151f8ab14082f39f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0fe7a61b527ad7a4037b87749ddb223da141e73757d4266ac64148c4f411edb"
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
