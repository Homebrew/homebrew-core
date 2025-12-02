class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "110b0a416b6f94c4654ac31b240395e415c642e4a83af11f0fad2126dfa9237c"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a49c0fa55021f88a3f8c658083946bc049f5920ce9ef831dfb2f84c67376f3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56017c6be0977b895c4cabe77f016df3386eed97b081e2c66bbc7fb1e1067ebb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fb251cd783f29eb194b2214f3dc33a15b906d88e9b88336bebd48a4cbf20d13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "427855b807581225b458b77abdf85ec85a7078e747032769925b1585d2eb8b81"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0b463a978cce6be0a7cffe431fdf2683c490cc640c131fb4367a102885ea99e"
    sha256 cellar: :any_skip_relocation, ventura:       "5e939831d1930895e26566c71ba99271286206c1aac03497c96e395aaf3e3c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b229f48a550fb95e559a57002a32141aac154fa8dff1a6ce2fb7a4f71022eac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc894ad7d0d759c3e07b042658ddf839144109f2abe3af664e3a3f8ae7d3bd8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
