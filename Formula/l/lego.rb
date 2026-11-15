class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "3ea1e82a23e001ed90ff48e7ad1f19d14ce7a50d211ad5c37610f54a918e26d1"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dcbc2993edf1c6efad9b5d7b525598316f1824e74aa2ead2873a67475e526d69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dcbc2993edf1c6efad9b5d7b525598316f1824e74aa2ead2873a67475e526d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcbc2993edf1c6efad9b5d7b525598316f1824e74aa2ead2873a67475e526d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04ff052238b8d18a9f7ee7cfe0c2baf20ddd84579733273ccd0c2de23e43669e"
    sha256 cellar: :any,                 x86_64_linux:      "7fa677668dfe339a37daf373ef3d4c341fa52b5c966cd9c111e51f2ba043e1c3"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
