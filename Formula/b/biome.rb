class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.6.5.tar.gz"
  sha256 "0fce71ab77fcc17c4c3966681a90f5d7b8108bdb3d7e091fde57aab7b6386cd1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1dd38a1751ba6d33b4c5536774fa0319a0ae1d7a20e360bb7d7eac20fa96d5a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1ff5a6d033f04ff2916e72fc288b89195b25efce1267839b2409b79cf6f8244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7b60c2f26cf40f243779162d348f2f4f943c0bb52641cf639fc7ad1db4bb942"
    sha256 cellar: :any,                 arm64_linux:       "53775e3bca20cce1a1a67b8f009191c88d18a965b5ec1be60e6d16b10cc055ad"
    sha256 cellar: :any,                 x86_64_linux:      "70d03e555c89555195836ec42b5f9bf5b9d6c897f08930e8c5325f31884893cd"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
