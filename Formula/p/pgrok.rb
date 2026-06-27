class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "9d5173d71e223fe77cfbbc9e22dd49a81e2d6452c1d1697b448de81053906213"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cc4316588fc9dd8256529e2603af087cb25a773c75edfe144cdcdcb9eb4b3df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cc4316588fc9dd8256529e2603af087cb25a773c75edfe144cdcdcb9eb4b3df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc4316588fc9dd8256529e2603af087cb25a773c75edfe144cdcdcb9eb4b3df"
    sha256 cellar: :any_skip_relocation, sonoma:        "65a83fa6b41e44398de7b7483ebb76cb42364af6f6aeaf8b87aed387e34392cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "417bcb806c49c3558edf96cd78c65f59c45ad6e9e0ce88cdee17cd9bab36536b"
    sha256 cellar: :any,                 x86_64_linux:  "313a290f8352249c5febcd021621a41ddd78c3a66e8cefc778147e8535e94e23"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./pgrok/cli"

    etc.install "pgrok.example.yml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    system bin/"pgrok", "init", "--remote-addr", "example.com:222",
                                "--forward-addr", "http://localhost:3000",
                                "--token", "brewtest"
    assert_match "brewtest", (testpath/"pgrok/pgrok.yml").read

    assert_match version.to_s, shell_output("#{bin}/pgrok --version")
  end
end
