class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "6222359c4a1ea3106c0a13d470806ed833bfbc7a1d10bd91aa3f4701927031b0"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c22e8b27dddf03f2d284ad7e2c52253af0b2fcdf99e659b0412aca0abb507cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c8437e377626604b3c60ecf0a93942276d7981e18402ed0312d2da7ffde3b06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4de219fb06a06fa4fb45d7623bda26345d7f1ca91d8a963b3747c805edd034f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4de99ef7a9206a2adbdc0c1d91c0c1614338a3ace18700ac75c127725c836873"
    sha256 cellar: :any_skip_relocation, ventura:       "78f243bdbcae80d65405ac24eb110f31b820401b141491ecf18c3a7c5e8dffb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca408d706026e9cb54aae6f6b0ade858d3f21c26f35da8522df5cc942c307975"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin/"nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output(bin/"nextdns start 2>&1", 1)
  end
end
