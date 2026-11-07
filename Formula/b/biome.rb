class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.6.6.tar.gz"
  sha256 "c0588dd352e9bebcf8de334baf0b5a120fa50933b57787b277e720e7057cb476"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "416b70c0e2244b488f970c347066db86ecf0f678a15fdd021cf63fb88ef29e55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a236fe26bf758de820abd4f976a82284cce2dae1f11044af0f8f452428e733f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1ec631304d656a2e55be516deaca4d265745e0862adb042450c9728c6ead69b"
    sha256 cellar: :any,                 arm64_linux:       "dddeaa02fd107d6c88c0cd9d325581c5612236fc894db8e55054d3e431879693"
    sha256 cellar: :any,                 x86_64_linux:      "24fb88b9cbc63a22cb728dbd3dcbc76049d9576bb4e3308a0158be60f37fb612"
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
