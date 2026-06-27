class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://codesnap-docs.netlify.app/"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "47a249efd507c0e1dcd8122da1d263b2bf00dcedfa27eed976a02909cefe0725"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff6961fc8c9d81bf69304432f627a7c33e420608e56fa17ecf187b0b13a6add"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc1c3738ff61d15705c6f4c38cc7333ab75fdd6d4a75d2e5724ecff551077f27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49d54a5c6f8412da05adc1590c232effadbedf39db56858f20ffdda24aa732c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb5271ddd2000221108755ff494d6755d41cabe14246b0dc44b4680341cbcc5"
    sha256 cellar: :any,                 arm64_linux:   "f50a021cefd64ecc6e46a5ed16344b830ea3b6bb8faddaf261a90c15c1f8c94f"
    sha256 cellar: :any,                 x86_64_linux:  "c2e28e5a0f2cec79d889c950cd5d933c9bc4a99244063cdd6acb86234f19b325"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")
    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
