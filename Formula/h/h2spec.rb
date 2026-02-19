class H2spec < Formula
  desc "Conformance testing tool for HTTP/2 implementation"
  homepage "https://github.com/summerwind/h2spec"
  url "https://github.com/summerwind/h2spec.git",
      tag:      "v2.6.0",
      revision: "70ac2294010887f48b18e2d64f5cccd48421fad1"
  license "MIT"
  head "https://github.com/summerwind/h2spec.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2b7fe0e0aa9921896c8bf719e6e505bac52613cba9289ff99f1c1b5b9810ce0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c838540f260b348701c7911092e08e52b6e6395ffb442ddd65e47ab7d4b606ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eccfc65c379b50c2b3c83f6ef56c3cf581e9568e0ec1e8d23d55253dae5c180a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85916701e8dd7c4caaef314e26c48344423369b3b2197bd80111141a9b526a38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2589ab8277cf827e7903a523b666e8ceb1b4fe5b494f0fcd52ac5b40706a5c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90d9e00cce2bd7659510bb75cc6735b94d7488207a4aeb665fd9aedae3ed8ca1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b4ac641cb3543d796da56ede9ab23924cddac7d16b73d1b75072b90ee498651"
    sha256 cellar: :any_skip_relocation, ventura:        "f64b879c82616e820a77e8c39c65a6fd6b957c069aabd31ef5f2478b14101d46"
    sha256 cellar: :any_skip_relocation, monterey:       "512863844a450dba5025fa2d09c88fb9e86e72e62ac43d0a19d2cc020e0b8467"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee24c3ab807d25dc92116e1b794d319365b7ad7a801f9ef9089f2992844673aa"
    sha256 cellar: :any_skip_relocation, catalina:       "c585fbaa7e8d101d280edafce5e26b4df57a1ac8ddbd7327f1efdc07d0ac17a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e0136fe36d0a1694d8b744638b909606cbba86bbd6b176b1a0aaddd1e1da1efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72f6c447db109aa6a6bceb41aed5fcc445ce1008633b8e236e457d686915990"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X main.VERSION=#{version}
      -X main.COMMIT=#{commit}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/h2spec"
  end

  test do
    assert_match "1 tests, 0 passed, 0 skipped, 1 failed",
      shell_output("#{bin}/h2spec http2/6.3/1 -h httpbin.org 2>&1", 1)

    assert_match "connect: connection refused",
      shell_output("#{bin}/h2spec http2/6.3/1 2>&1", 1)
  end
end
