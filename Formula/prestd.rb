class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.1.3.tar.gz"
  sha256 "64df1a85556705161da82ee3bfe07eeff513faac4cd95d20a71f37f98777841f"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc9a26c76d5db65cbed04e5326f70a0ff740da258fc158aab1845fe8ad5d3c4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4e5afbfbe5beef3756d59f329631b68cfd169cc8ff8d87d5d27a1406ad38ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "50ada4487014050d8cc7b03327e499e03d00f6210fe45f0c75794b19032bcac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "76ca3f6448a3853404ca8a71b6ccf6e2cefd93d631c058d35cff5a4833333675"
    sha256 cellar: :any_skip_relocation, catalina:       "ee58fb4d5bc089880ac2769efc572984bd83da41032ffba74b8deedf0a67aec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e38dc08bb4788dd41bcb7a1e147ecfde55bf93e7b28b25cfbaf0beddbb00a803"
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
