class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.12.1.tar.gz"
  sha256 "63f25355e5e480bcb6cc570e4b94eda2ec0a2f9c00385c29196f1ec990fd2401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1f4b70782d700b8b4078d0c3e903d49185a9e99aa938cf4c79dfe18f5ec801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1f4b70782d700b8b4078d0c3e903d49185a9e99aa938cf4c79dfe18f5ec801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e1f4b70782d700b8b4078d0c3e903d49185a9e99aa938cf4c79dfe18f5ec801"
    sha256 cellar: :any_skip_relocation, ventura:        "da3cdeb42a778c96027787b47a3b6fbef63ebe2271055c55fa434b5063329f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "da3cdeb42a778c96027787b47a3b6fbef63ebe2271055c55fa434b5063329f0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "da3cdeb42a778c96027787b47a3b6fbef63ebe2271055c55fa434b5063329f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d007e7cdf1e52b6220ba0645e6722507091c10f937cf568e888f33b5d05dad96"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
