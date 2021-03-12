class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.3.1.tar.gz"
  sha256 "98b5d267a491cacdb901311acf3c360a2f2d03c389a700917c5ca0e43374b508"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c8fbe8f8fe9b92627f4acd7b3fd92ec18e0f2aa78e6508fbfc252d44bf39530"
    sha256 cellar: :any_skip_relocation, big_sur:       "2871b27fe3a4d1fc400825cfa337e68f456df2d0ad0dd5319b3037e81460ad46"
    sha256 cellar: :any_skip_relocation, catalina:      "8d68c52daaa52e31b9558484470c797994f262fd4434ab46791f4adbfddbdf3b"
    sha256 cellar: :any_skip_relocation, mojave:        "54edb4620e4c9a8035e46382056e95dc2f06c2d500967880e0b2da5c4e3bf9a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
