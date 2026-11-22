class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "5ee0696186293ae613de662a5d88bfa863b2f32f6be333c2a38fe4c902add2e9"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    manifest_sha256 "8e4d467d1ff67dfd970a6b24e3e799e61d8d5bc4f242ecef4f3f08730cc1e295"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0d1798e3069c9461389bf2a563c5fc258e8cd8114e9052e2e1544d39a44bc79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c67a8b2691a87dd5e414596acc90b20a9d70f2770f4cf864975379c9fa6997a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a709a16a56982044f283a498774a916a87de010fd92b236cc3759d4f9231e98"
    sha256 cellar: :any,                 arm64_linux:       "ece85bf33d97faa44aa60cfc96e4b42513b0b8ad0e90ec2234371d31422313da"
    sha256 cellar: :any,                 x86_64_linux:      "f666eb225569ebba71ea5807719bb38d86bf7814d76ea5be61a904f409da1ba5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")

    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
