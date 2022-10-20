class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.9.0.tar.gz"
  sha256 "e54b21f8e12a98af7476cf376a1b816889d2a9424bd80ec367abb5d6eaf0e4c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b459ae434751269f9617982d96ac4eb721921207764b7614ffdac9afa1fed5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd2228ebdc275f0c925abe2735907407794da96175ed87ccfab0fe406fe74346"
    sha256 cellar: :any_skip_relocation, monterey:       "797dc9a2d419c10285c53736d1ec53a7535becee13aa8700a3821d6cf44c172b"
    sha256 cellar: :any_skip_relocation, big_sur:        "40da3449408ade9d0e9f0f826d3a1fa71c851413d2dbb4091b66c159cdba93e2"
    sha256 cellar: :any_skip_relocation, catalina:       "610a4519f76e00c1d5ce19a87e73b6c2c1d07d881d287cfbf1dbfefb3689685b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f048c3b47f70d71d19d076a2ed34ba48adf4ff986a03e0b0571650b848f558d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
