class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.6.8.tar.gz"
  sha256 "14e8a90df2b74e24bcee56065fc076c672deacc26b31767983f3df0860abcc1e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a10ddda39831ddcd485ce6029c5fb92c8679d15aff75b34be70c8254d33af72"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3a10300e1c59d687e161f14fc4e6fd221b5182f07d4ccf19923b744d905989f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15653a30af349d3d7d327b9ce8d1ff70eb46a2c9176cd459d5aa05ce6a5596bf"
    sha256 cellar: :any,                 arm64_linux:       "a395161968b545dc1e177b03a2936c556c8f13871f39cafca190dbb0d979efcd"
    sha256 cellar: :any,                 x86_64_linux:      "33cd35c84d81e2782e0343460708caa8a9a30a86f6f8f7c06e881bacc597a29d"
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
    # Use thin LTO on macOS to reduce build time.
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if OS.mac? || github_arm64_linux
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
