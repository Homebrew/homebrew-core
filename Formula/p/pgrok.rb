class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "16756e5b7c7e1a02e8deed679dd3c01807aa323457a2d72e943829c2cfe799c7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1aab6b97ced5de92663e6ed40de7e7e7f145328d03353fd7e4f2aa12a2e33e7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1aab6b97ced5de92663e6ed40de7e7e7f145328d03353fd7e4f2aa12a2e33e7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1aab6b97ced5de92663e6ed40de7e7e7f145328d03353fd7e4f2aa12a2e33e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0297f3dc0b17bfad599adc2a7b594faf20cb5599294d41b397ee44f609bd850c"
    sha256 cellar: :any,                 x86_64_linux:      "7e50799447900a343eb4bc2d17cd3f718dc6540f5b5c18816cfcf5352a86a7d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./pgrok/cli"

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
