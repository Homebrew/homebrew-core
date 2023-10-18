class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "1c02e727deef9a0f67da6517fe3b91ef965b2a66824b1a2e9fda7dac27c5a855"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc308afd717e3312c5d90e3fb503d4b3b313f262ea8c792b41c0b09ab2ae4b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d6a2e577cb1cc0189106e9953e0131e9c2efe48a9d31cc17c97dcfcdc3c809d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eb623622cf4fd2eef80f1d87b21a0192e3fe66418f10341f131cd1fb4133716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dda650f0d37bd886859fe735334598bac4d58847d1f0ce1172cf694be242f64b"
    sha256 cellar: :any_skip_relocation, sonoma:         "782d4b8534aaeeaca003c99f98341be98d9e93df7fff9378571edeaa83460d4d"
    sha256 cellar: :any_skip_relocation, ventura:        "d86f540bee6f77e059ff4185bb600aa05662b28790ffe0423bf0fdc4a59c3c22"
    sha256 cellar: :any_skip_relocation, monterey:       "39e26ad4fe3134975d74408da709c4e43581d7a266b080c33071f64c0964ef69"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ef2fa0fe1d0f0c574025e9566ed51d467976a81302d8f45d9a4fd36c1569047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ab569082bec0b39352f8175bf3d67a369af82ffe7c04315d73774c371ea9066"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
