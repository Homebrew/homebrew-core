class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.39.0.tar.gz"
  sha256 "46ecbd2bbf20634664e319b0c15526d580852c2e95b21900b0d2263b4bc44f8b"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9617912457e05ba7fa67185fcc0ca6d921712b62ba353354e80fba7da982101"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "407f8717804f958f65324b220e6c92a18f07cd5ccd4599ac74003354b4de4027"
    sha256 cellar: :any_skip_relocation, monterey:       "27231accb54777d1ac428eae3b98f890b4ca50609e1be578046c84181d0f3541"
    sha256 cellar: :any_skip_relocation, big_sur:        "37578d2b4862f43ecf23620491b4d8bb786765e5ab3c061c7ae1d8d6cc9392f0"
    sha256 cellar: :any_skip_relocation, catalina:       "f3bcd48ae0db217dc8d2ce0171af8aaf63dc805e204ffe7dd91681053e5ae729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e48e2f344ee8f5a47d92aa90282d00c27ced0e2afceb07d3b11008e5b1444bd4"
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
