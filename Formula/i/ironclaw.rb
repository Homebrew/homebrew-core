class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "da811a250f404b4da50dc10ac330e6db9e8c7edcd566f3113bbf422728ada627"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de70db37e36f34c59e5cf37879472e8b1016f1be52b8f09a1c8bf4ed32d3f532"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb7939a1a407fb65b1de921d2bf5933098642c25cb5e7aae1ed956f57dce8f98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13e290ff7ead18124a4d3034be5b808553b29ecedc20b5341a1ad54c1a418f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3927476923446a4fd381bba133a1f622b6e7929ed0ae4e777d842782c30c1f5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a247de2cddd371db4c9bf22bd022eaec24786a05125e312e1ea28113fe2652b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f0a5428bb98301f993ad442113a86689e6e2008a5f23696f99b34b90678bb3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end
