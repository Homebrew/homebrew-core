class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "edb4b2ef3aaf9a16d409e92b27ed1467494edebedcca8ad51060916b175e401b"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0640a6e10bcf5282b59ab11d54b3a3973aef75cda201bfef82ea154038874049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0640a6e10bcf5282b59ab11d54b3a3973aef75cda201bfef82ea154038874049"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0640a6e10bcf5282b59ab11d54b3a3973aef75cda201bfef82ea154038874049"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cea435db14b96a57869334e18959795cbc81374161dc21aef66a46474b01008"
    sha256 cellar: :any_skip_relocation, ventura:       "8cea435db14b96a57869334e18959795cbc81374161dc21aef66a46474b01008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45007bb3b43f295e163035bcb02ded4287029f227c936f42a632e6f3f4830675"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
