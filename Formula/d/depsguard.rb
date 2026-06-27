class Depsguard < Formula
  desc "Harden package manager configs against supply chain attacks"
  homepage "https://depsguard.com"
  url "https://github.com/arnica/depsguard/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "dcddbf0826245f33efa908a2d24b5c4c78bea587771a44a435a0f739d695587d"
  license "MIT"
  head "https://github.com/arnica/depsguard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b36f9fce889576d0e23f0c0c7cfdbfdaef5176361090b0dd297232abc500d65d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3342942fd269b00626a022365a4aba9b8a605a8a7d5a3b83ecfd02c83f3ee0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e7d4d50a4f982cce505a4bad2b02537e7c796c75eb357f34e7be11db64adc82"
    sha256 cellar: :any_skip_relocation, sonoma:        "2796da5257ee97e14b6df87b923f04b4472a8dacddd2f8ced3b36b05e46dbb9c"
    sha256 cellar: :any,                 arm64_linux:   "32300323892a77749891db3112970ebd9f1537273a85940d84decab636bb4ac7"
    sha256 cellar: :any,                 x86_64_linux:  "a76141692ac4d20029f4a237802367695a96cb12de9270cc13254cdd30272929"
  end

  depends_on "rust" => :build

  deny_network_access!

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depsguard --version")

    # With no package manager configs present, scanning the current directory
    # finds nothing to harden and exits successfully.
    system bin/"depsguard", "scan", "--no-search"
  end
end
