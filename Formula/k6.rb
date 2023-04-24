class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.44.0.tar.gz"
  sha256 "c0b8f518e0c6bb98fa9086e305f2cbae55c02cb3616673024d5cfd1c92b74ede"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "624b596a9c46dbd1febe82b81468700777e82aab0ad42e68bab2bad9fece0eb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dafb632b86c767f65ac09b1c4d15303587df78cc8c1a19b2dd356f033ec30319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "624b596a9c46dbd1febe82b81468700777e82aab0ad42e68bab2bad9fece0eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "efc88aae7ca4e31bb4ce580df22085ab53cc5dcecaedbf7998de01240d7d720f"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e04848eef51ac85fc74f3442ceeb0327c33f36b3f55c4a296d02d8b2781185"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9e04848eef51ac85fc74f3442ceeb0327c33f36b3f55c4a296d02d8b2781185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191329aee48e445b269979079c18cdc5221d0e0183298ef79efdac5cdf6dc43e"
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
