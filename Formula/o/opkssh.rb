class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "b7b933fa8184070ba230a1a3208620acfe2f85ef8005d0b91c15841584d364f1"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f05b98f30bf05b4f23846065771c2f13324a6646e51240264e8e9b320664ff0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f05b98f30bf05b4f23846065771c2f13324a6646e51240264e8e9b320664ff0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f05b98f30bf05b4f23846065771c2f13324a6646e51240264e8e9b320664ff0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "61b184ec85a25726b67344562759446e3704c3e75d93bc75243a837faf59ba67"
    sha256 cellar: :any,                 x86_64_linux:      "ac9661954e2ee32be2d1f79792b6941583015fa2d491e7170d7ddf96bce61a3f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
