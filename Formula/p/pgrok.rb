class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "9bec95b33c5773c5c3b85886f4bffe56ac4321c38941c36e717c9c0931e46f93"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d5186a932f6f7d4a8158be261c494ff8031d88f7e2ebe7468cb59f2e9bcaec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5186a932f6f7d4a8158be261c494ff8031d88f7e2ebe7468cb59f2e9bcaec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d5186a932f6f7d4a8158be261c494ff8031d88f7e2ebe7468cb59f2e9bcaec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f69cfd8543a90d77cb8146f49dc1ec06c35101e2214daac083b1d3969c22bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e8df264bf0d3360544c451550b59b5779856b2abd2e1b15eb246455b55c8fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09fa7db4fd8c819fc026194d598e6a87f76cb4f7ec5aad786c85d1e569394232"
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
