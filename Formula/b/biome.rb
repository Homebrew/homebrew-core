class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.14.tar.gz"
  sha256 "5b87b7df94e8c6b968d44daecf92c46231908012be5f6f41ac33bcabbd53e66e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f88c7683746e1e3f2c88c5e6257754a5c35731b6e6166d4feaa30fb629b9ea9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33be538f2023ca710dc85d948a2c7472de5cda0292cfc33b8c92283cc2778371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96bdf96848c3bfc2b8535c39a8a6b92d74306626c071fc9ae9c6568fc8840a89"
    sha256 cellar: :any,                 arm64_linux:       "e49169d64fda53b9cd28e6bb1935459c62b96f6a8c2a6b51d128ae93c5406890"
    sha256 cellar: :any,                 x86_64_linux:      "b47b6f7a021d58a8fa0b3d7a1a5018f6b3855111f84f1b0d999c22c9bd0f0ec0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end
