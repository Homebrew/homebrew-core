class Jprq < Formula
  desc "Join Public Router, Quickly"
  homepage "https://jprq.io/"
  url "https://github.com/azimjohn/jprq/archive/refs/tags/2.4.tar.gz"
  sha256 "a3fc5a804851129c79a02deb3e5b7f5b84c0f351d688ca0088b571407399ff30"
  license "BSD-3-Clause"
  head "https://github.com/azimjohn/jprq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6195dfee83fd21ef69de93949b49ac904954ab516c301a0a92900f6c9d6f9c6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dccb9dad79cf8951cceb2c9d53e25a393b796bcf34470f538715054fc1005236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dccb9dad79cf8951cceb2c9d53e25a393b796bcf34470f538715054fc1005236"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dccb9dad79cf8951cceb2c9d53e25a393b796bcf34470f538715054fc1005236"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0061191f55e023d50c1bc33534c827564d6f1e9dbf82e5adabf6fac707eccd0"
    sha256 cellar: :any_skip_relocation, ventura:       "d0061191f55e023d50c1bc33534c827564d6f1e9dbf82e5adabf6fac707eccd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad7f038e996d116f06bffe8ddc2192d0ba296ef2a615bcfd899644727eddb33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e246f6c4571348c952e771002559477ef11baf395722922e74038113a20ea012"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cli"
  end

  test do
    assert_match "auth token has been set", shell_output("#{bin}/jprq auth jprqbolmagin 2>&1")
    output = shell_output("#{bin}/jprq serve #{testpath} 2>&1", 1)
    assert_match "authentication failed", output

    assert_match version.to_s, shell_output("#{bin}/jprq --version 2>&1")
  end
end
