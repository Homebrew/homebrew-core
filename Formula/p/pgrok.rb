class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "32c92b405329f00b29253594cab23feba66ccf01f4f44ae8ecb69271312cfd09"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "024d140439771b7addfbda3b694f59e648dc6798d2e7c47ee3d3501a5326215a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "024d140439771b7addfbda3b694f59e648dc6798d2e7c47ee3d3501a5326215a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "024d140439771b7addfbda3b694f59e648dc6798d2e7c47ee3d3501a5326215a"
    sha256 cellar: :any_skip_relocation, sonoma:        "21534c47eb53ec0f56e513a24f050b1a35e7692103abab6de5a3f840e8aedf3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14124f6cb5c517feeed5002d3093dc3fe7759a19c5840d42accd8bce42f93304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92469698f5f77c88d479f3a712e46870a2e400b559ee6a06196ca5fd873d5de7"
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
