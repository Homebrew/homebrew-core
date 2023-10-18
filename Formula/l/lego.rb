class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.14.2.tar.gz"
  sha256 "30118c803167d7711b0a40741eef53f7a2ff40b87f4cef936adb916b09ccf3a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6b7fcdbe5e1a6ed0561bc9cdddd82da596eb4bbf8b277e38ba291a89569d266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "553a586352751a25255d6ad3acda2661b1ff38d5cb2cc51cc266294a3d1bc50e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c181b3a8417143f22eb1c1733e00ef6695279ba4eb599ccb8bfe09c1582f4d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89a9e56e44e5d141d834d89138b8f89e25edb843ce68260cfd3d0c3bed3290e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "97c292c25e38f97a3f5710cfb183be3ee98bd306bf1e5b5f5d369dcc0b130376"
    sha256 cellar: :any_skip_relocation, ventura:        "8748ec6c8d9162c9204738e6127e6eae9f4aae23043ee35333ea2c82fa02944b"
    sha256 cellar: :any_skip_relocation, monterey:       "d575b22f69f92279a25d411329165b229cabff9a5b682f127ec6a5aa9c25dfab"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb635cd3847f4764c838e4a80a493bff4c29d5df720d43e3fc3a4d82f8ae872c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0af4e497feec896e0a9a62d90b4ea439ff8d0a7bf8a1a2a62a917fb443a65c3"
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
