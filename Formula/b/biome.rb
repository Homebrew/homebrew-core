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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "675e770c83d2409210150f6502898956cdee4c11e65b5a0038a92e915420379d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c50fb9289b475a135a1f94c91a1abf5bd13ddcbf6b31a4261a9e446c8e5c7730"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c549f8be7fee31d954be722d5932631b36c629b17bffe404a98ec65744872b6a"
    sha256 cellar: :any,                 arm64_linux:       "9b2793f5c055ec58ef0dfcd6c7335b5230b649c3396707f851748426f84cf51c"
    sha256 cellar: :any,                 x86_64_linux:      "adf11f2824b19e9a017ce44e6ae0b6895d1e3dd606e70c0a09b1bcfa8a8b36a4"
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
