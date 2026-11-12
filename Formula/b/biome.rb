class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.6.7.tar.gz"
  sha256 "4a17edfe38a4437040d1f12ebd41a78bebec056522351c446c451b856b7e9cf4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f78d4e279087dfad1d72ec1f782b89eb3ecbb72aecb85139d506ba912f3126ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "183fe0431e86075f89c915aac6e2648bd403ca7ae3792915dab696b97bdb8987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09dd97cd59b0088c21bc5550ddd74742f3a108fd50f92a734131e0cff1edac93"
    sha256 cellar: :any,                 arm64_linux:       "9a793a80f7cc7e45c3280a9adc9a44e724906d4fdadb177e720648a4b99c9c7f"
    sha256 cellar: :any,                 x86_64_linux:      "fd1b3e9a07e356e9f916eb919e7c302147361ddc9cbc431a74cc42ac1084c8d1"
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
