class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.5.2.tar.gz"
  sha256 "4f3a831543597f47f0c1e7fb8c8c40a0dd672e4558da67362928b4c3839c6656"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b80255ff87356e3dd62631f9ed993d00bfad618a1043a72fb99760579bbf2aa8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4974e09c4987194385978bd34a47f6c67a63714ae7fcf408b26df7e23df4916c"
    sha256 cellar: :any_skip_relocation, catalina:      "19f7188943f12b8ac3e74f68fa49e0e191ffef9e75973d52d8acc85bf6eb13da"
    sha256 cellar: :any_skip_relocation, mojave:        "89cca544cdc1e28d9287e2498a7f30091afc79a3f4803952bbab8b7860dc4fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d411b26a7e36d1a85e49dc0ffac0a0f87d1b2d219fdfd17e385ee202bfc1223"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
