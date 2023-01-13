class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.2.0.tar.gz"
  sha256 "00360d70839e0ff5ba1b5f5c7a57f17af20a9730960c37f70cdd5d77d3b70d16"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3eacec7a731ab90dcfea66bc18fcdb6f9f2106faf01f0f5e6c73edbc2bc20c2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed993bac96c9b39cc534fd6e34bfb407efbfe11b2fc8d90d87ee28c08a9fa11e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f62fe4c0777cb2442c15e396d5c762f8a26d47ff85124fc0d7f3e02f7b34cff7"
    sha256 cellar: :any_skip_relocation, ventura:        "831e37c5e5d30985cbe6e696a6ac4a0ba6dca0248f9430ccdb373ff72fbda71e"
    sha256 cellar: :any_skip_relocation, monterey:       "fbfecec64364f1cb9649519b56f0a2d434e6f9f29966e22a2bc035d81cc4a28e"
    sha256 cellar: :any_skip_relocation, big_sur:        "51a4dbf4bb0924fe50319cbe60f9f0f041ffcd96ff614ef6f28293af80894fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec28de31998248677c910befd869d7e5acca406e0fc1c9d71087045587ddd998"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}",
      "./cmd/prestd"
  end

  test do
    (testpath/"prest.toml").write <<~EOS
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    EOS

    output = shell_output("prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prestd version")
  end
end
