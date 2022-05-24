class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.6.0.tar.gz"
  sha256 "a7101491392309b1549be0394c5e3d368f2dae3fcc351f6f653fe4b33ffd4bee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd1ec81c6d2428c082d5804d9eb506f7105948db3d12a1a82169961c80484a66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03fb5f8f2ac1790094807c3891e882e725e576c9529e45474f2e03b57e4d1ce5"
    sha256 cellar: :any_skip_relocation, monterey:       "d0f4b0c26427c607dd8606fb43f84069ae57c9779378a69be6dacf536428c616"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9d7b1af751e4bd3b65bdcec0b681d255b9329b82679850a4418c186557d87fc"
    sha256 cellar: :any_skip_relocation, catalina:       "f39f671a7ef8f95ed3ee2b30f493ad93c9b53490f9228063ee0008a1a13d7f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67056e62ed928cbdf90ead32e075ed3adf27dc908791bcbdd1db78c649e6f76d"
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
