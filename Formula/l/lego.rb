class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "4692d2481042349c758eb0f7ee04904c4e1c26afc145e25b0833a42777c5ee72"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ae10c6de9ba82fbbedb7ad5935f1d86379bdb057bdaf3f3c119390a17b9ee0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ae10c6de9ba82fbbedb7ad5935f1d86379bdb057bdaf3f3c119390a17b9ee0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae10c6de9ba82fbbedb7ad5935f1d86379bdb057bdaf3f3c119390a17b9ee0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "09aa4a7fedbf965dee3929aafdd3ee11f59a0fec5edac0707b90e22152cc143e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a68b4c78c39c03a792a99e5f245e0bab300d8a3a3f5c387341626fc4b6274f8"
    sha256 cellar: :any,                 x86_64_linux:  "20b56eb63cb58ce795fc4dff8db6a612f4386998c1372da686d8973f67caa3ac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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
