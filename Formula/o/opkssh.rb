class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "27f46aeab36e7cb67bba4f945eb95e6f0f137b6276dcb5a8d46dc1ee8c68b0cb"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ec70ead93ad2656e47a728fd668013b96dd03572096a4c3e109453acb78524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ec70ead93ad2656e47a728fd668013b96dd03572096a4c3e109453acb78524"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19ec70ead93ad2656e47a728fd668013b96dd03572096a4c3e109453acb78524"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb5b1b0ebd86db9351942633b268c3e1bf59e7745870783e0cb2627f77aa908d"
    sha256 cellar: :any_skip_relocation, ventura:       "bb5b1b0ebd86db9351942633b268c3e1bf59e7745870783e0cb2627f77aa908d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc1d15b09f4761790688c96cbe0f13f107843cb7061070f9600ef0cf2324257"
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
