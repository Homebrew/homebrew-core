class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.38.3.tar.gz"
  sha256 "3ee4b4892a9965c336efc97b3fc9e179be0652331aecaf79e90d42dce8825c26"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c175e4dad587cd2ece5c809a848e4f6cd785c28942250d69c4beea4d1b3a59b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "679ea08e9f762b80881e7061656a4cf35261848b986209e5a0b0612619c434fb"
    sha256 cellar: :any_skip_relocation, monterey:       "425fcf2d7114684ca8077860ed1e21d82f58cc52e2363155066bdbbf02565fe0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c012abdae9eb02cd30991b46041af30cd232b3c6a6de54c8fd3c7d014274e7a"
    sha256 cellar: :any_skip_relocation, catalina:       "ed4cc6bd295985f2bb51116b561f74973eb3cdd1832d3999eb5b980a4325f3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4d9c3d4e2896eb6a0f0ef5de869f21aab9decf14220e902140b7bc5d77ae715"
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
