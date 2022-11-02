class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "81d3b603e258bb008bff345863c5275382d52b97cb4605a6dafd5b5a2c3dff6d"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b417f48d20bdb6ef5c2b83abc7b02edc25ae6f3416a8c85dd89523bd20a55b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56d07afb27f15d731002c1624eb7c318cd1ff381e211a133b653e8ae77f98fc1"
    sha256 cellar: :any_skip_relocation, monterey:       "fa701caf300476eb0648399d43c577b364cef21146719b327308d621d113d526"
    sha256 cellar: :any_skip_relocation, big_sur:        "da19858bdf86b62215f491c10d5fe92edecbd5bc39c64ae985d0ffa0d02179d4"
    sha256 cellar: :any_skip_relocation, catalina:       "ddc1c547cf532095765effdb9b66f3b20a20a57b56766be9b2cc5eda5dc1299c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ff9dd6d2a771d57240a27c79c446ff3d4d4ea198a902564333990487c5f8ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cassowary"
  end

  test do
    system("#{bin}/cassowary", "run", "-u", "http://www.example.com", "-c", "10", "-n", "100", "--json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
