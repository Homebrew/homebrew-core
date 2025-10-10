class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "71796c060705411e98fc7d11d944c531cea1d09df14cc1331c5647a31483de41"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44ad548c145cb779e6d50733b58db55b117d4329729b70fe0cffdc3279498c24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ad548c145cb779e6d50733b58db55b117d4329729b70fe0cffdc3279498c24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44ad548c145cb779e6d50733b58db55b117d4329729b70fe0cffdc3279498c24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44ad548c145cb779e6d50733b58db55b117d4329729b70fe0cffdc3279498c24"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a35524a4291410b6ceea50271ae654dd7eb893739a1c40968e734c08e82b5ff"
    sha256 cellar: :any_skip_relocation, ventura:       "4a35524a4291410b6ceea50271ae654dd7eb893739a1c40968e734c08e82b5ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e5ae721162aa37d4c09a40aca5e253e21cf32e601b9a8ed0abbc22fe2e7078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "164ecd36445fc15136df17384e10271908eedece6c8e1b1a1b4f56a7d8fcf782"
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
