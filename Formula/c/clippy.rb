class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "273dede89fa4e71e89e08110e2fa311e6113163200a729b10fa4bae7438e1734"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d56315c8b5715ce38f80305fee1a5419ceeff3b377ebf4af44baca9442c8ceb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6baf95c9b46564042bc070913757346e2412ae936e89abe732afd696539cdb70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffa61a2bb334c1c15f2f9acbc48728e0489b6f17108fbab93cb07d43c28b00e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d29c8e5773677d027e66ddf636619055b6e97531e4861081795514b0c1a365a"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end
