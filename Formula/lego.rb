class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.10.1.tar.gz"
  sha256 "00ec83dba03ea6d33e163ef9362d2411338711c2b73c3153fbdf125ff80e0aea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848259d3a6043787046c08fea51323ecad44bd4a4ae6e2689bdbe09cb89ef69b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acdd213220350dc00fe75d9dfc17d9515b8c720a6ee1bf3d69bf7b26cb77ffd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f092828ed73b7934857527d21650a6f572e0bb51852d96bafe8b3f2727465ab7"
    sha256 cellar: :any_skip_relocation, ventura:        "ca901a4d850eb96f87fa493366975696a7639dee224318ef83da5dc4c01c342c"
    sha256 cellar: :any_skip_relocation, monterey:       "0543d22e9b4acb02822d27a514835ed286307272c56116502d7e1040b258137b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4f375f1430ab42b3b046f5af17981183d17f73e8d15f91bdc6df9a8bfb011e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af5d1246d356700ff76e9b545fbf360af3d464fd6aa35956e85d94493caf968e"
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
