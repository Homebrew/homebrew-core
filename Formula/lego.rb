class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.7.0.tar.gz"
  sha256 "c0eea1bf280ae28559f1e10dac777fc0d1e9cd520f9c9ab2368591c16587271e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec95a75df8434533b4883c5b049d37ff5f7f1f7690fac8abc86089d595cbea37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e6eb7653a30384207373e3374c1ad773f22d44881b1c5c89d1f53c39511e995"
    sha256 cellar: :any_skip_relocation, monterey:       "9461227b026ef980d5ac0aaca62df4f637e8a32611cc6fea304a3df0ef5e12c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4ef5f9f784e6500e196bbca9f5af7d546f8f9a530b0e1abc3a95d7461f4c0a7"
    sha256 cellar: :any_skip_relocation, catalina:       "f93f1345c405c8c80c4551dbcec1e1d5e732226c6829ea49972bdb349ed9119c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af2f4a984388a476ea3fd29092568433f0320471e4fa138c33a009ad3596c027"
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
