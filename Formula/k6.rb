class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.38.1.tar.gz"
  sha256 "d48dc59008cdd565c8362b064889770da11069f75719aa001aeab7dd92f4a1b5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abb97b2ba0877d01aed3810e34cb9b051a9ac360ac5622919061fe03005a018b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bcd094d1158ee7b6446d7364477ab32d279dd2167161e0b7156779405bd65fb"
    sha256 cellar: :any_skip_relocation, monterey:       "75b56dc9a2d2a6ff5516f8fc8b7bd574de68f265fa3dfd16192f985239e53ad9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b71f02e9bb9e77acdbd1ebf035f27ccc5476923ead5d36d2206c1b4301469cd"
    sha256 cellar: :any_skip_relocation, catalina:       "0ece95aefcbebe5951f92eee9b1e67d3b6a956ba4694169d230a731059920745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7f76dfa07fa1a2054a2f937896220efe05d69bd533a7a972c40fd2a64eef40"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
