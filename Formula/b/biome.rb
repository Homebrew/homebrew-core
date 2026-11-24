class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.6.9.tar.gz"
  sha256 "eb1dc14f5c3a4c824dbd80d07458a5f891a22b7042379f2d999d867b947a943d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    manifest_sha256 "871218ce6938c240fef46d92328cd73f555334e27f9e9a7abb244f20a3777dbb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37cf04864992e59002acdfcfc5bd0793d27e70c76537b94597f58a04dff340c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9721ef286c28879f681cfe2bec5a9a88e25a98adcf71424e231baf27ef4a6c67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba766aeef5a6b45c2f60f4ce401934c206ee2d1a6644a3cd76abb5aad201d8cd"
    sha256 cellar: :any,                 arm64_linux:       "ffd0b4d4e6796b3a4f5e0abe99eda1c7eb918a2e1ba395fb9e6834eea4fc382d"
    sha256 cellar: :any,                 x86_64_linux:      "5865c009a3650361c6f66fac16b7c8ed4a9be94ed1ef300c2f17393d27e5d2a1"
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
