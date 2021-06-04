class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.48.tar.gz"
  sha256 "80ba78e471ac6281fcccab83c8dd52956f3e35fb15e41d78a92e847120bb13c4"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d54de81ad725d2e7f98ff4a716f8e22c2b974588701d6733137a6347e632a26d"
    sha256 cellar: :any_skip_relocation, big_sur:       "aef9a59bef984a837e5197396a1449a206901f0d687d979a9aa56be30db2f8fe"
    sha256 cellar: :any_skip_relocation, catalina:      "d88f8b100cdd2030046b1242c8b3aee63c5ff02d3a314d1540dcbf93c108bcd3"
    sha256 cellar: :any_skip_relocation, mojave:        "d80a4b38e9a2cc1e2b714d8d946de5054dd6c4fe7c10bccdf6434ba70ea834ba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
