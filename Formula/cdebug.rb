class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "a49a824bbe7c643d745866a0dc7540ddb49665da21fd9c4501c2358a56d0fdf6"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00a57bb6e7c0922c08d780f3db250223a02446175c959ac615d35d7a45ffcdb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ace751fd134f36c16e03872f9d7b78f784c70a8538749f932281aa3740706d42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b90a5f8a72ea3c37e0134a4a6ea9e8fc25c9888c09c36d94f5601b5ecc5d20ee"
    sha256 cellar: :any_skip_relocation, ventura:        "92a9221e4d6bf8ce903b2b24f5ce48ceb55967f68b0f007b4ccfcf2e6e4ff18c"
    sha256 cellar: :any_skip_relocation, monterey:       "1967d8ba355b78bd0e2631c5b185d5f1b4fdac2f9a47ab13f6fb20092fb94e0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "52bf8fd5b4995a9ae3c92dc391869716489c26960019aa750edba84a0a3a1261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29ea8c6570bce895044130861f114fbaac740c0adcb1ebb4f4c513f2f4f04881"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Got permission denied while trying to connect to the Docker daemon"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
