class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.21.3.tar.gz"
  sha256 "7172868464014bc09b687a70254c658b664d53abf17f07394c8d3692bb891722"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed2a9d654021ca1aa8068270296766ac4c4482912c2b1322a2ef1329c8f32e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db3212b080fb68319038398a573c1a2b4563acc6b2828c0a0a080e766a7d5ec8"
    sha256 cellar: :any_skip_relocation, monterey:       "a519fe0b15a7337dc2c668d795398885771f3c274ea7e8a33b157b2c846e4cb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a9fcd0661fc37a4e49f20b1c186b38b6e4ef4716cddd1054caf85828090db7d"
    sha256 cellar: :any_skip_relocation, catalina:       "09c1a63e2d419d13a5986c88edd13a58a4ab201f4888ac8919d0cd47b60362de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8762e82a24dc4a4a3c4292038107a0d39e23d010cb3cc630a99c3b7eb4495830"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
